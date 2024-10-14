cmake_minimum_required(VERSION 3.22)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)

if(APPLE)
execute_process(COMMAND plutil -extract CFBundleIdentifier raw /Library/Developer/Toolchains/swift-latest.xctoolchain/Info.plist OUTPUT_VARIABLE TOOLCHAINS OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND xcrun --toolchain ${TOOLCHAINS} -f swiftc OUTPUT_VARIABLE CMAKE_Swift_COMPILER OUTPUT_STRIP_TRAILING_WHITESPACE)
message("CMAKE_Swift_COMPILER: ${CMAKE_Swift_COMPILER}")
endif()
set(CMAKE_Swift_COMPILER_WORKS true)
if(PICO_PLATFORM STREQUAL "rp2350-arm-s")
set(CMAKE_Swift_COMPILER_TARGET armv7em-none-none-eabi)
else()
set(CMAKE_Swift_COMPILER_TARGET armv6m-none-none-eabi)
endif()
string(JOIN " " CMAKE_Swift_FLAGS
    "-Xcc -mfloat-abi=soft -Xcc -fshort-enums"
    "-Xfrontend -function-sections -enable-experimental-feature Embedded -wmo -parse-as-library"
)

project(pico-swift LANGUAGES C CXX ASM Swift)
pico_sdk_init()

set(SWIFT_DEFINES
    $<$<STREQUAL:${PICO_PLATFORM},rp2040>:PICO_RP2040;PICO_ARM>
    $<$<STREQUAL:${PICO_PLATFORM},rp2350-arm-s>:PICO_RP2350;PICO_ARM>
    $<$<STREQUAL:${PICO_BOARD},pico_w>:PICO_W>
)
set(DEFINES
    $<TARGET_PROPERTY:pico-swift,COMPILE_DEFINITIONS>
    $<$<STREQUAL:${PICO_BOARD},pico_w>:PICO_W>
)
set(INCLUDE_DIRECTORIES
    $<TARGET_PROPERTY:pico-swift,INCLUDE_DIRECTORIES>
    ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES}
    $<$<STREQUAL:${PICO_BOARD},pico_w>:$ENV{PICO_SDK_PATH}/lib/lwip/src/include>
)

file(GLOB_RECURSE SWIFT_LIST ${CMAKE_CURRENT_LIST_DIR}/src/*.swift)
add_library(swiftcode STATIC ${SWIFT_LIST})
target_compile_options(swiftcode PRIVATE
    "SHELL:-D$<JOIN:${SWIFT_DEFINES}, -D>"
    "SHELL:-Xcc -D$<JOIN:${DEFINES}, -Xcc -D>"
    "SHELL:-Xcc -I$<JOIN:${INCLUDE_DIRECTORIES}, -Xcc -I>"
    -import-bridging-header ${CMAKE_CURRENT_LIST_DIR}/include/BridgingHeader.h
)

add_executable(pico-swift)
target_link_libraries(pico-swift
    pico_stdlib hardware_uart hardware_gpio
    "$<$<STREQUAL:${PICO_BOARD},pico_w>:pico_lwip_arch;pico_cyw43_arch_none>"
    ${CMAKE_CURRENT_BINARY_DIR}/libswiftcode.a
)
target_include_directories(pico-swift PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include)
add_dependencies(pico-swift swiftcode)
pico_add_extra_outputs(pico-swift)
pico_enable_stdio_usb(pico-swift 1)

# convert compile_commands.json for SourceKit-LSP and C/C++ IntelliSense
get_target_property(SWIFTCODE_COMPILE_OPTIONS swiftcode COMPILE_OPTIONS)
execute_process(COMMAND
    python3 ${CMAKE_CURRENT_LIST_DIR}/tools/convert_compile_commands.py
    --build ${CMAKE_CURRENT_BINARY_DIR}
    --input ${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json
    --output ${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json
    --cc ${CMAKE_C_COMPILER}
    --c_cpp_properties ${CMAKE_CURRENT_LIST_DIR}/.vscode/c_cpp_properties.json
    --wait_cmake
)
