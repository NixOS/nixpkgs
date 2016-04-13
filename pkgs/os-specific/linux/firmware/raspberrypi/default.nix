{stdenv, fetchurl }:

let

  rev = "1.20160315";

in stdenv.mkDerivation {
  name = "raspberrypi-firmware-${rev}";

  src = fetchurl {
    url = "https://github.com/raspberrypi/firmware/archive/${rev}.tar.gz";
    sha256 = "0a7ycv01s0kk84szsh51hy2mjjil1dzdk0g7k83h50d5nya090fl";
  };

  installPhase = ''
    mkdir -p $out/share/raspberrypi/boot
    cp -R boot/* $out/share/raspberrypi/boot
    cp -R hardfp/opt/vc/* $out
    cp opt/vc/LICENCE $out/share/raspberrypi

    for f in $out/bin/*; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$f"
      patchelf --set-rpath "$out/lib" "$f"
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
