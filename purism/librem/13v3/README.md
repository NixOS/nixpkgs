This config is for [Librem 13v3](https://puri.sm/products/librem-13/) and [15v3](https://puri.sm/products/librem-15/) Laptops from Purism.


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

## Adding a PureOS partition to the GRUB menu

I first assume that `boot.loader.grub.useOSProber = true;` should be sufficient.
However GRUB was not able to identify the disks correctly and it took me several
reinstallation till setting `boot.loader.grub.fsIdentifier= "provided";` and using
boot.loader.grub.extraEntries allowed me to dual boot NixOS and PureOS.

Be aware that each time the PureOS updates the /boot/grub/grub.cfg you will be unable
to boot into NixOS unless you patch grub.cfg manually again.

Therefore: If you want to be able to boot into your old PureOS distribution
add the following lines, assuming that you have a separate boot partition
Adapt linux version and the UUID to your disk!!


```nix
{
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.fsIdentifier= "provided";
  boot.loader.grub.extraEntries = ''
  menuentry "PureOS with linux 4.19.0-5-amd64 on /dev/sdb2 " {
      insmod gzio
      if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
      insmod part_msdos
      insmod ext2
      set root='hd0,msdos1'
      if [ x$feature_platform_search_hint = xy ]; then
        search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1  ef7a4dcf-8cc4-4870-b860-3ed64906f9b9
      else
        search --no-floppy --fs-uuid --set=root ef7a4dcf-8cc4-4870-b860-3ed64906f9b9
      fi
      linux   /vmlinuz-4.19.0-5-amd64 root=UUID=43899f26-04f2-4ccb-b52a-c9441f1a1a6d ro  quiet splash resume=UUID=923317f8-d8bb-4e1f-bca3-f36a556de609 # $vt_handoff
      initrd  /initrd.img-4.19.0-5-amd64
  };
}
```
