{lib, stdenv, fetchurl, libX11, imake, gccmakedep}:

stdenv.mkDerivation rec {
  pname = "xskat";
  version = "4.0";

  nativeBuildInputs = [ gccmakedep ];
  buildInputs = [ libX11 imake ];

  src = fetchurl {
    url = "http://www.xskat.de/xskat-${version }.tar.gz";
    sha256 = "8ba52797ccbd131dce69b96288f525b0d55dee5de4008733f7a5a51deb831c10";
  };

  preInstall = ''
    sed -i Makefile \
      -e "s|.* BINDIR .*|   BINDIR = $out/bin|" \
      -e "s|.* MANPATH .*|  MANPATH = $out/man|"
  '';

  installTargets = [ "install" "install.man" ];

  meta = with lib; {
    description = "Famous german card game";
    platforms = platforms.unix;
    license = licenses.free;
    longDescription = "Play the german card game Skat against the AI or over IRC.";
    homepage = "http://www.xskat.de/";
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
