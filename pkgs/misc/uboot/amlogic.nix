{ buildUBoot
, buildPackages
, armTrustedFirmwareS905
, armTrustedFirmwareTools
, firmwareAmlogic
, firmwareOdroidC4
, meson-tools
}:

# The Amlogic builds of U-Boot are more involved than the usual other simpler 
# upstream U-Boot builds.
#
# Amlogic uses a set of signed binary firmware files as an initial boot stage,
# and there is no Free Libre or Open source replacement available.

{
  ubootOdroidC2 = buildUBoot {
    defconfig = "odroid-c2_defconfig";

    nativeBuildInputs = [
      armTrustedFirmwareTools
      meson-tools
    ];

    FIPDIR = "${firmwareAmlogic}/odroid-c2";
    BL31 = "${armTrustedFirmwareS905}/bl31.bin";

    postBuild = ''
      # BL301 image needs at least 64 bytes of padding after it to place
      # signing headers (with amlbootsig)
      truncate -s 64 bl301.padding.bin
      cat $FIPDIR/bl301.bin bl301.padding.bin > bl301.padded.bin

      # The downstream fip_create tool adds a custom TOC entry with UUID
      # AABBCCDD-ABCD-EFEF-ABCD-12345678ABCD for the BL301 image. It turns out
      # that the firmware blob does not actually care about UUIDs, only the
      # order the images appear in the file. Because fiptool does not know
      # about the BL301 UUID, we would have to use the --blob option, which adds
      # the image to the end of the file, causing the boot to fail. Instead, we
      # take advantage of the fact that UUIDs are ignored and just put the
      # images in the right order with the wrong UUIDs. In the command below,
      # --tb-fw is really --scp-fw and --scp-fw is the BL301 image.
      #
      # See https://github.com/afaerber/meson-tools/issues/3 for more
      # information.
      fiptool create \
        --align 0x4000 \
        --tb-fw $FIPDIR/bl30.bin \
        --scp-fw bl301.padded.bin \
        --soc-fw $BL31 \
        --nt-fw u-boot.bin \
        fip.bin
      cat $FIPDIR/bl2.package fip.bin > boot_new.bin
      amlbootsig boot_new.bin u-boot.img

      # Extract u-boot from the image
      dd if=u-boot.img of=u-boot.bin bs=512 skip=96

      # Ensure we're not accidentally re-using this transient u-boot image
      rm u-boot.img

      # Pick bl1.bin.hardkernel from FIPDIR so it can be installed in filesToInstall.
      cp $FIPDIR/bl1.bin.hardkernel ./

      # Create the .img file to flash from sector 0x01 (bs=512 seek=1)
      # It contains the remainder of bl1.bin.hardkernel and u-boot
      dd if=bl1.bin.hardkernel of=u-boot.img conv=notrunc bs=512 skip=1 seek=0
      dd if=u-boot.bin         of=u-boot.img conv=notrunc bs=512 seek=96

      # Help out the user a little.
      cat > README.md <<EOF
      Since the GXB boot flow starts at sector 0x00, the user needs to
      flash the first 442 bytes themselves.

          $ dd if=bl1.bin.hardkernel of=... conv=fsync,notrunc bs=1 count=442
          $ dd if=u-boot.img         of=... conv=fsync,notrunc bs=512 seek=1
      EOF
    '';

    filesToInstall = [
      "README.md"
      "u-boot.img"
      "bl1.bin.hardkernel"
    ];
    extraMeta.platforms = ["aarch64-linux"];
  };

  ubootOdroidC4 = buildUBoot {
    defconfig = "odroid-c4_defconfig";

    postBuild = ''
      ${buildPackages.meson64-tools}/bin/pkg --type bl30 --output bl30_new.bin \
        ${firmwareOdroidC4}/bl30.bin ${firmwareOdroidC4}/bl301.bin
      ${buildPackages.meson64-tools}/bin/pkg --type bl2 --output bl2_new.bin \
        ${firmwareOdroidC4}/bl2.bin ${firmwareOdroidC4}/acs.bin

      ${buildPackages.meson64-tools}/bin/bl30sig --input bl30_new.bin \
        --output bl30_new.bin.g12a.enc --level v3
      ${buildPackages.meson64-tools}/bin/bl3sig --input  bl30_new.bin.g12a.enc \
        --output bl30_new.bin.enc --level v3 --type bl30
      ${buildPackages.meson64-tools}/bin/bl3sig --input ${firmwareOdroidC4}/bl31.img \
        --output bl31.img.enc --level v3 --type bl31
      ${buildPackages.meson64-tools}/bin/bl3sig --input u-boot.bin --compress lz4 \
        --output bl33.bin.enc --level v3 --type bl33 --compress lz4
      ${buildPackages.meson64-tools}/bin/bl2sig --input bl2_new.bin \
        --output bl2.n.bin.sig

      ${buildPackages.meson64-tools}/bin/bootmk --output u-boot.bin \
        --bl2 bl2.n.bin.sig --bl30 bl30_new.bin.enc --bl31 bl31.img.enc --bl33 bl33.bin.enc \
        --ddrfw1 ${firmwareOdroidC4}/ddr4_1d.fw \
        --ddrfw2 ${firmwareOdroidC4}/ddr4_2d.fw \
        --ddrfw3 ${firmwareOdroidC4}/ddr3_1d.fw \
        --ddrfw4 ${firmwareOdroidC4}/piei.fw \
        --ddrfw5 ${firmwareOdroidC4}/lpddr4_1d.fw \
        --ddrfw6 ${firmwareOdroidC4}/lpddr4_2d.fw \
        --ddrfw7 ${firmwareOdroidC4}/diag_lpddr4.fw \
        --ddrfw8 ${firmwareOdroidC4}/aml_ddr.fw \
        --ddrfw9 ${firmwareOdroidC4}/lpddr3_1d.fw \
        --level v3
    '';

    filesToInstall = [ "u-boot.bin" "${firmwareOdroidC4}/sd_fusing.sh"];
    extraMeta.platforms = ["aarch64-linux"];
  };
}
