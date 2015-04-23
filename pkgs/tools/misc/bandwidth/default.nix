{ stdenv, fetchurl, nasm }:

let
  arch =
    if      stdenv.system == "x86_64-linux" then "bandwidth64"
    else if stdenv.system == "i686-linux" then "bandwidth32"
    else if stdenv.system == "x86_64-darwin" then "bandwidth-mac64"
    else if stdenv.system == "i686-darwin" then "bandwidth-mac32"
    else if stdenv.system == "i686-cygwin" then "bandwidth-win32"
    else null;
in
stdenv.mkDerivation rec {
  name = "bandwidth-1.1b";

  src = fetchurl {
    url = "http://zsmith.co/archives/${name}.tar.gz";
    sha256 = "01c3ca0x3rh65j1s2g6cg5xr9fvm0lp2wpmv71vhz55xwqqqmiz8";
  };

  buildInputs = [ nasm ];

  buildFlags = [ arch ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${arch} $out/bin
    ln -s ${arch} $out/bin/bandwidth
  '';

  meta = with stdenv.lib; {
    homepage = https://zsmith.co/bandwidth.html;
    description = "and artificial benchmark for identifying weaknesses in the memory subsystem";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
