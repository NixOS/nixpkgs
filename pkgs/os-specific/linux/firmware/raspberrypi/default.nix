{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "raspberrypi-firmware-${version}";
  version = "1.20160620";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = version;
    sha256 = "06g691px0abndp5zvz2ba1g675rcqb64n055h5ahgnlck5cdpawg";
  };

  installPhase = ''
    mkdir -p $out/share/raspberrypi/boot
    cp -R boot/* $out/share/raspberrypi/boot
    cp -R hardfp/opt/vc/* $out
    cp opt/vc/LICENCE $out/share/raspberrypi

    for f in $out/bin/*; do
      if isELF "$f"; then
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$f"
        patchelf --set-rpath "$out/lib" "$f"
      fi
    done
  '';

  meta = with stdenv.lib; {
    description = "Firmware for the Raspberry Pi board";
    homepage = https://github.com/raspberrypi;
    license = licenses.unfree;
    platforms = [ "armv6l-linux" "armv7l-linux" ];
    maintainers = with maintainers; [ viric tavyc ];
  };
}
