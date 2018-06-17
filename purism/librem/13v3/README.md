Librem comes with Coreboot + SeaBIOS payload. That means EFI boot is not
possible. Use `fdisk` to partition hard drive, and GRUB as a bootloader:

```nix
{
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    version = 2;
  };
}
```
