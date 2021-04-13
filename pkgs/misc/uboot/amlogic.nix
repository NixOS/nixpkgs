{ buildUBoot
, armTrustedFirmwareS905
, armTrustedFirmwareTools
, firmwareAmlogic
, gxlimg
, libfaketime
, meson-tools
, meson64-tools
}:

# The Amlogic builds of U-Boot are more involved than the usual other simpler 
# upstream U-Boot builds.
#
# Amlogic uses a set of signed binary firmware files as an initial boot stage,
# and there is no Free Libre or Open source replacement available.

# Identifying the SoC family
#
# The "linux-meson" development community wiki will tell you which family the
# SoC for your board is using.
#
#  - https://linux-meson.com/doku.php#target_hardware
#
# Additionally, the build instructions generally hint at it through the binary
# tools names, e.g. `aml_encrypt_gxl` is for `GXL`.

let
  # Recognizable by the use of `aml_encrypt_g12a` or `aml_encrypt_g12b`
  buildUBootMesonG12A = { FIPDIR, ... } @ args: buildUBoot ({
    nativeBuildInputs = [
      libfaketime
      meson64-tools
    ];

    postBuild = ''
      meson64-pkg --type bl30 --output bl30_new.bin \
        $FIPDIR/bl30.bin $FIPDIR/bl301.bin

      meson64-pkg --type bl2 --output bl2_new.bin \
        $FIPDIR/bl2.bin $FIPDIR/acs.bin

      meson64-bl30sig --input bl30_new.bin \
        --output bl30_new.bin.g12a.enc --level v3

      meson64-bl3sig --input  bl30_new.bin.g12a.enc \
        --output bl30_new.bin.enc --level v3 --type bl30

      meson64-bl3sig --input $FIPDIR/bl31.img \
        --output bl31.img.enc --level v3 --type bl31

      # The lz4 compression here introduces a timestamp in the build.
      faketime -f "1970-01-01 00:00:01" \
      meson64-bl3sig --input u-boot.bin --compress lz4 \
        --output bl33.bin.enc --level v3 --type bl33 --compress lz4

      meson64-bl2sig --input bl2_new.bin \
        --output bl2.n.bin.sig

      bootmk_args=(
        --bl2 bl2.n.bin.sig
        --bl30 bl30_new.bin.enc
        --bl31 bl31.img.enc
        --bl33 bl33.bin.enc

        --ddrfw1 $FIPDIR/ddr4_1d.fw
        --ddrfw2 $FIPDIR/ddr4_2d.fw
        --ddrfw3 $FIPDIR/ddr3_1d.fw
        --ddrfw4 $FIPDIR/piei.fw
        --ddrfw5 $FIPDIR/lpddr4_1d.fw
        --ddrfw6 $FIPDIR/lpddr4_2d.fw
        --ddrfw7 $FIPDIR/diag_lpddr4.fw
      )

      # ddrfw 8 through 9, according to U-Boot documentation, are not always
      # present.

      if test -e $FIPDIR/aml_ddr.fw; then
        bootmk_args+=( --ddrfw8 $FIPDIR/aml_ddr.fw )
      fi

      if test -e $FIPDIR/lpddr3_1d.fw; then
        bootmk_args+=( --ddrfw9 $FIPDIR/lpddr3_1d.fw )
      fi

      bootmk_args+=( --level v3 )

      meson64-bootmk --output u-boot.bin \
        "''${bootmk_args[@]}"

      # Help out the user a little.
      cat > README.md <<EOF
      The boot firmware is installed in the "unused" space after the MBR.

          $ dd if=u-boot.bin of=... conv=fsync,notrunc bs=512 seek=1
      EOF
    '';

    filesToInstall = [ "u-boot.bin" "README.md" ];
    extraMeta.platforms = ["aarch64-linux"];
  } // args);

  # Recognizable by the use of `aml_encrypt_gxl`
  buildUBootMesonGXL =
    { FIPDIR, ... } @ args: buildUBoot ({
    nativeBuildInputs = [
      gxlimg
    ];
    
    postBuild = ''
      # Sign BL2
      python3 $FIPDIR/acs_tool.py $FIPDIR/bl2.bin ./bl2_acs.bin $FIPDIR/acs.bin 0
      sh $FIPDIR/blx_fix.sh \
        ./bl2_acs.bin \
        ./tmp.zero \
        ./tmp.bl2.zero.bin \
        $FIPDIR/bl21.bin \
        ./tmp.bl21.zero.bin \
        ./bl2_new.bin \
        bl2
      gxlimg -t bl2 -s bl2_new.bin bl2.bin.enc

      # Sign Bl3*
      sh $FIPDIR/blx_fix.sh \
        $FIPDIR/bl30.bin \
        ./tmp.zero \
        ./tmp.bl30.zero.bin \
        $FIPDIR/bl301.bin \
        ./tmp.bl301.zero.bin \
        ./bl30_new.bin \
        bl30
      gxlimg -t bl3x -c bl30_new.bin     bl30.bin.enc
      gxlimg -t bl3x -c $FIPDIR/bl31.img bl31.img.enc

      # Encrypt U-Boot
      gxlimg -t bl3x -c u-boot.bin u-boot.bin.enc
      gxlimg -t fip \
        --bl2 ./bl2.bin.enc \
        --bl30 ./bl30.bin.enc \
        --bl31 ./bl31.img.enc \
        --bl33 ./u-boot.bin.enc \
        ./gxl-boot.bin
      mv -v gxl-boot.bin u-boot.bin

      # Prepare USB boot files
      dd if=u-boot.bin of=u-boot.bin.usb.bl2 bs=49152 count=1
      dd if=u-boot.bin of=u-boot.bin.usb.tpl skip=49152 bs=1

      # Help out the user a little.
      cat > README.md <<EOF
      This firmware can be installed to the SPI Flash if your board has one.
      Installing to the SPI Flash is preferred.

      Alternatively, the boot firmware can be installed in the "unused" space
      after the MBR of either the SD card or the eMMC.

          $ dd if=u-boot.bin of=... conv=fsync,notrunc bs=512 seek=1

      * * *

      The `u-boot.bin.usb.*` files are meant to be booted through USB.
      Look at [pyamlboot](https://github.com/superna9999/pyamlboot) for more
      information. End-users generally don't need to care about these files.
      EOF
    '';

    filesToInstall = [ "u-boot.bin" "u-boot.bin.usb.bl2" "u-boot.bin.usb.tpl" "README.md" ];
    extraMeta.platforms = ["aarch64-linux"];
  } // args);
in
{
  inherit buildUBootMesonG12A;

  ubootOdroidC2 = buildUBoot {
    # Amlogic S905 / GXBB
    # This uses a bespoke build because while it's GXBB, the binaries from the
    # vendor are not as expected.
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

  ubootOdroidC4 = buildUBootMesonG12A {
    # Amlogic S905X3 / SM1, G12A compatible build
    defconfig = "odroid-c4_defconfig";
    FIPDIR = "${firmwareAmlogic}/odroid-c4";
  };
}
