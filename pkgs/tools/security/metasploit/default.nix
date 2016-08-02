{ stdenv, fetchurl, makeWrapper, ruby }:

stdenv.mkDerivation rec {
  name = "metasploit-framework-${version}";
  version = "3.3.1";

  src = fetchurl {
    url = "http://downloads.metasploit.com/data/releases/archive/framework-${version}.tar.bz2";
    sha256 = "07clzw1zfnqjhyydsc4mza238isai58p7aygh653qxsqb9a0j7qw";
  };

  buildInputs = [makeWrapper];

  installPhase = ''
    mkdir -p $out/share/msf
    mkdir -p $out/bin

    cp -r * $out/share/msf

    for i in $out/share/msf/msf*; do
        makeWrapper $i $out/bin/$(basename $i) --prefix RUBYLIB : $out/share/msf/lib
    done
  '';

  postInstall = ''
    patchShebangs $out/share/msf
  '';

  meta = {
    description = "Metasploit Framework - a collection of exploits";
    homepage = https://github.com/rapid7/metasploit-framework/wiki;
    platforms = stdenv.lib.platforms.unix;
  };
}
