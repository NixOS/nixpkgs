{ stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation rec {
  version = "2016-09-30";
  name = "xcwd-${version}";

  src = fetchFromGitHub {
    owner   = "schischi";
    repo    = "xcwd";
    rev     = "3f0728b";
    sha256  = "0lwfz6qg7fkiq86skp51vpav33yik22ps4dvr48asv3570skhlf9";
  };


  buildInputs = [ libX11 ];

  makeFlags = "prefix=$(out)";

  installPhase = ''
    mkdir -p "$out/bin"
    install xcwd "$out/bin"
  '';

  meta = {
    description = "xcwd - X current working directory";
    homepage = https://github.com/schischi/xcwd;
    maintainers = [ stdenv.lib.maintainers.grburst ];
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
  };
}
