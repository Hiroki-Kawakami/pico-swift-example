@main
struct Main {
    static func main() {
        stdio_init_all()

        let led = UInt32(PICO_DEFAULT_LED_PIN)
        gpio_init(led)
        gpio_set_dir(led, true)

        while true {
            print("Hello World!")

            gpio_put(led, true)
            sleep_ms(250)
            gpio_put(led, false)
            sleep_ms(250)
        }
    }
}
