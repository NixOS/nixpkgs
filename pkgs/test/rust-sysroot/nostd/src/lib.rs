#![no_std]

#[panic_handler]
fn panic(_: &core::panic::PanicInfo) -> ! {
  loop {}
}
