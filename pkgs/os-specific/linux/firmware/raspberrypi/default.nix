{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "raspberrypi-firmware-${version}";
  version = "1.20170303";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = version;
    sha256 = "1s5dycgix97681vpq7ggpc27n865wgv9npzxvbr2q2bp3ia9mcim";
  };

  dontStrip = true;    # Stripping breaks some of the binaries

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
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ viric tavyc ];
  };
}
