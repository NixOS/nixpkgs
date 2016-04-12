{ stdenv
, fetchgit
, makeWrapper
, pkgs
, libusb1
}:

with pkgs.lib;

stdenv.mkDerivation rec {
  version = "2014-11-26";
  name = "psoc-programmer-${version}";

  src = fetchgit {
    url = "https://github.com/lowfatcomputing/PSOC_programmer";
    rev = "1e13b2136792ef27f8c70f2f03b1b23858dec72a";
    sha256 = "1adc0fe6b1c60e5fdd7f0396aca6a73ed5595c305499926040df6f8b649aa404";
  };

  buildInputs = [ libusb1 makeWrapper ];

  installPhase = ''
    # software
    make INC=" -I../libhex -I../libini -I${pkgs.libusb1}/include -I." LIBS=" -L${pkgs.libusb1}/lib ../libhex/libhex.a ../libini/libini.a -lusb-1.0" INSTALL_DIR=$out/bin install

    # wrapper around verbose config path etc.
    cat <<EOF > $out/bin/psoc-prog
    #!/usr/bin/env bash
    $out/bin/prog -C $out/etc/psoc-programmer -d PSOC5LP-xxx \$*
    EOF
    chmod +x $out/bin/psoc-prog

    # device config
    install -Dm644 config/config.ini $out/etc/psoc-programmer/config.ini
    install -Dm644 config/devices.dat $out/etc/psoc-programmer/devices.dat
    install -Dm644 config/fx2_kim_dump.hex $out/etc/psoc-programmer/fx2_kim_dump.hex
    install -Dm644 config/fx2lp_fw.hex $out/etc/psoc-programmer/fx2lp_fw.hex
    install -Dm644 config/nm.hex  $out/etc/psoc-programmer/nm.hex

    # docs
    install -Dm644 README.md $out/share/doc/psoc-programmer/README.md
    install -Dm644 TODO $out/share/doc/psoc-programmer/TODO
    install -Dm644 docs/* $out/share/doc/psoc-programmer/
  '';

  meta = {
    description = "Open source tools to manipulate hex files and program a PSoC5 via FX2 USB interface";
    homepage = "https://github.com/kiml/PSOC_programmer";
    license = with stdenv.lib.licenses; [ gpl3Plus ];
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ lowfatcomputing ];
  };
}

