@main
struct Main {
    static func main() {
        stdio_init_all()

        xTaskCreate({ _ in
            let led = LED()
            while true {
                print("Hello")
                led.enabled = !led.enabled
                vTaskDelay(1000 / UInt32(portTICK_PERIOD_MS))
            }
        }, "blink", 256, nil, 1, nil)

        vTaskStartScheduler()
        while true {}
    }
}
