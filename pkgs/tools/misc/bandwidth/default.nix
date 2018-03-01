{ stdenv, fetchurl, nasm }:

let
  arch =
    if      stdenv.system == "x86_64-linux" then "bandwidth64"
    else if stdenv.system == "i686-linux" then "bandwidth32"
    else if stdenv.system == "x86_64-darwin" then "bandwidth-mac64"
    else if stdenv.system == "i686-darwin" then "bandwidth-mac32"
    else if stdenv.system == "i686-cygwin" then "bandwidth-win32"
    else throw "Unknown architecture";
in
stdenv.mkDerivation rec {
  name = "bandwidth-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "http://zsmith.co/archives/${name}.tar.gz";
    sha256 = "1v9k1a2ilkbhc3viyacgq88c9if60kwsd1fy6rn84317qap4i7ib";
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
    maintainers = with maintainers; [ wkennington ];
  };
}
