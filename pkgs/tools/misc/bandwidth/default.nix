{ stdenv, fetchurl, nasm }:

let
  arch =
    if      stdenv.hostPlatform.system == "x86_64-linux" then "bandwidth64"
    else if stdenv.hostPlatform.system == "i686-linux" then "bandwidth32"
    else if stdenv.hostPlatform.system == "x86_64-darwin" then "bandwidth-mac64"
    else if stdenv.hostPlatform.system == "i686-darwin" then "bandwidth-mac32"
    else if stdenv.hostPlatform.system == "i686-cygwin" then "bandwidth-win32"
    else throw "Unknown architecture";
in
stdenv.mkDerivation rec {
  pname = "bandwidth";
  version = "1.9.3";

  src = fetchurl {
    url = "https://zsmith.co/archives/${pname}-${version}.tar.gz";
    sha256 = "0zpv2qgkbak0llw47qcakhyh2z3zv4d69kasldmpdlpqryd9za84";
  };

  buildInputs = [ nasm ];

  buildFlags = [ arch ]
    ++ stdenv.lib.optionals stdenv.cc.isClang [ "CC=clang" "LD=clang" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${arch} $out/bin
    ln -s ${arch} $out/bin/bandwidth
  '';

  meta = with stdenv.lib; {
    homepage = https://zsmith.co/bandwidth.html;
    description = "Artificial benchmark for identifying weaknesses in the memory subsystem";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
