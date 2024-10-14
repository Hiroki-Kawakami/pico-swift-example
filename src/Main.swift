@main
struct Main {
    static func main() {
        stdio_init_all()

        let led = LED()
        while true {
            print("Hello")
            led.enabled = !led.enabled
            sleep_ms(1000)
        }
    }
}
