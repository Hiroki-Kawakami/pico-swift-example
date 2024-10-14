cmake_minimum_required(VERSION 3.22)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(APPLE)
execute_process(COMMAND plutil -extract CFBundleIdentifier raw /Library/Developer/Toolchains/swift-latest.xctoolchain/Info.plist OUTPUT_VARIABLE TOOLCHAINS OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND xcrun --toolchain ${TOOLCHAINS} -f swiftc OUTPUT_VARIABLE CMAKE_Swift_COMPILER OUTPUT_STRIP_TRAILING_WHITESPACE)
message("CMAKE_Swift_COMPILER: ${CMAKE_Swift_COMPILER}")
endif()
set(CMAKE_Swift_COMPILER_WORKS true)
set(CMAKE_Swift_COMPILER_TARGET armv6m-none-none-eabi)
string(JOIN " " CMAKE_Swift_FLAGS
    "-Xcc -mfloat-abi=soft -Xcc -fshort-enums"
    "-Xfrontend -function-sections -enable-experimental-feature Embedded -wmo -parse-as-library"
)

include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)
project(pico-swift LANGUAGES C CXX ASM Swift)
pico_sdk_init()

file(GLOB_RECURSE SWIFT_LIST ${CMAKE_CURRENT_LIST_DIR}/src/*.swift)
add_library(swiftcode STATIC ${SWIFT_LIST})
target_compile_options(swiftcode PRIVATE
    "SHELL:-Xcc -DPICO_RP2040"
    "SHELL:-Xcc -I${CMAKE_CURRENT_LIST_DIR}/include"
    "SHELL:-Xcc -I$<JOIN:$<TARGET_PROPERTY:pico-swift,INCLUDE_DIRECTORIES>, -Xcc -I>"
    "SHELL:-Xcc -I$<JOIN:${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES}, -Xcc -I>"
    -import-bridging-header ${CMAKE_CURRENT_LIST_DIR}/include/BridgingHeader.h
)

add_executable(pico-swift)
target_link_libraries(pico-swift
    pico_stdlib hardware_uart hardware_gpio
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
