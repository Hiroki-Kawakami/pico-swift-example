final class LED {

    enum LEDPin {
        case gpio(UInt32)
        #if PICO_W
        case cyw43(UInt32)
        #endif
    }

    #if PICO_W
    static private var cyw43Initialized = false;
    convenience init() {
        let ledPin = UInt32(CYW43_WL_GPIO_LED_PIN)
        self.init(ledPin: .cyw43(ledPin))
    }
    #else
    convenience init() {
        let ledPin = UInt32(PICO_DEFAULT_LED_PIN)
        self.init(ledPin: .gpio(ledPin))
    }
    #endif

    let ledPin: LEDPin
    init(ledPin: LEDPin) {
        self.ledPin = ledPin
        if case .gpio(let pin) = ledPin {
            gpio_init(pin)
            gpio_set_dir(pin, true)
        }
        #if PICO_W
        if case .cyw43 = ledPin, !LED.cyw43Initialized  {
            if cyw43_arch_init() == 0 {
                LED.cyw43Initialized = true
            } else {
                fatalError("Failed to initialize CYW43")
            }
        }
        #endif
    }
    convenience init(ledPin: Int) {
        self.init(ledPin: .gpio(UInt32(ledPin)))
    }

    var enabled: Bool = false {
        didSet {
            if case .gpio(let pin) = ledPin {
                gpio_put(pin, enabled)
            }
            #if PICO_W
            if case .cyw43(let pin) = ledPin, LED.cyw43Initialized {
                cyw43_arch_gpio_put(pin, enabled)
            }
            #endif
        }
    }
}
