{stdenv, fetchurl, libX11, imake, gccmakedep}:


let
  s = # Generated upstream information
  rec {
    baseName="xskat";
    version="4.0";
    name="${baseName}-${version}";

    url="http://www.xskat.de/xskat-4.0.tar.gz";
    hash="8ba52797ccbd131dce69b96288f525b0d55dee5de4008733f7a5a51deb831c10";
    sha256="8ba52797ccbd131dce69b96288f525b0d55dee5de4008733f7a5a51deb831c10";
  };
   buildInputs = [ libX11 imake gccmakedep ];
in

stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  preInstall = ''
    sed -i Makefile \
      -e "s|.* BINDIR .*|   BINDIR = $out/bin|" \
      -e "s|.* MANPATH .*|  MANPATH = $out/man|"
  '';
  installTargets = [ "install" "install.man" ];
  meta = {
    inherit (s) version;
    description = ''Famous german card game'';
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.free;
    longDescription = ''Play the german card game Skat against the AI or over IRC.'';
    homepage = http://www.xskat.de/;
  };
}
