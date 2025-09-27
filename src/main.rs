//! Blinks the LED on a Pico W board
//!
//! This will blink the onboard LED on a Pico W, which is controlled via the CYW43 WiFi chip.
#![no_std]
#![no_main]

use defmt::*;
use embassy_executor::Spawner;
use embassy_rp::gpio;
use embassy_time::{Duration, Timer};
use gpio::{Level, Output};
use {defmt_rtt as _, panic_probe as _};

#[embassy_executor::main]
async fn main(_spawner: Spawner) {
    info!("Program start");
    let p = embassy_rp::init(Default::default());

    // For regular GPIO LED (if you connect an external LED to a GPIO pin)
    let mut led_pin = Output::new(p.PIN_22, Level::Low);

    // Note: For the onboard LED on Pico W, you'd need to use the CYW43 driver
    // This example uses a regular GPIO pin. See the embassy examples for CYW43 usage.

    loop {
        info!("on!");
        led_pin.set_high();
        Timer::after(Duration::from_millis(1500)).await;
        info!("off!");
        led_pin.set_low();
        Timer::after(Duration::from_millis(1500)).await;
    }
}
