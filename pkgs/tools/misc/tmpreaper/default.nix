{ stdenv, fetchurl, autoconf, automake }:

let
  inherit (stdenv.lib) optional;
  sha256-default = "1ca94d156eb68160ec9b6ed8b97d70fbee996de21437f0cf7d0c3b46709fecbc";
  sha256-ventura = "714d2ff483bc2027650c7fd229d3244fae4213e7d1a26a73e14e75f4fa1c61b2";
  sha256-arm64_ventura = "6f9987a8435e18ce63b2214cd6bedbb56902c09c8cf88614c0dfab73d418c003";
in
stdenv.mkDerivation rec {
  pname = "tmpreaper";
  version = "1.6.17";
  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_${version}.tar.gz";
    sha256 = if stdenv.hostPlatform.system == "x86_64-darwin" then
      if stdenv.hostPlatform.cpu == "x86_64" then sha256-default
      else sha256-arm64_ventura
    else if stdenv.hostPlatform.system == "aarch64-darwin" then sha256-default
    else if stdenv.hostPlatform.system == "x86_64-linux" then sha256-default
    else sha256-ventura;
  };
  homepage = "https://packages.debian.org/sid/tmpreaper";
  description = "Clean up files in directories based on their age";
  license = "GPL-2.0-only";
  maintainers = with stdenv.lib.maintainers; [ maintainer ];

  buildInputs = [ autoconf automake ];
  doCheck = false;

  installPhase = ''
    mkdir -p $out/sbin
    cp tmpreaper $out/sbin
    mkdir -p $out/share/man/man8
    cp tmpreaper.8 $out/share/man/man8
  '';
}
