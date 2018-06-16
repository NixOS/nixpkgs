{ stdenv, fetchurl, coreutils }:

stdenv.mkDerivation rec {
  name = "brightnessctl-${version}";
  version = "0.3.2";

  src = fetchurl {
    url = "https://github.com/Hummer12007/brightnessctl/archive/0.3.2.tar.gz";
    sha256 = "92687d8739b8395cf942287bdb8905a78b428102ab6029680829ab917363e0ab";
  };

  patchPhase = ''
    substituteInPlace 90-brightnessctl.rules --replace /bin/ ${coreutils}/bin/
    substituteInPlace 90-brightnessctl.rules --replace %k '*'
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/man/man1,etc/udev/rules.d}
    install -D brightnessctl $out/bin
    install -D brightnessctl.1 $out/share/man/man1
    install -D 90-brightnessctl.rules $out/etc/udev/rules.d
  '';

  meta = {
    homepage = "https://github.com/Hummer12007/brightnessctl";
    license = stdenv.lib.licenses.mit;
    description = "This program allows you read and control device brightness";
    platforms = stdenv.lib.platforms.linux;
  };

}
