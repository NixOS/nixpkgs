{ lib, stdenv, fetchFromGitHub, pkg-config, fuse, pcre }:

stdenv.mkDerivation {
  pname = "rewritefs";
  version = "2017-08-14";

  src = fetchFromGitHub {
    owner  = "sloonz";
    repo   = "rewritefs";
    rev    = "33fb844d8e8ff441a3fc80d2715e8c64f8563d81";
    sha256 = "15bcxprkxf0xqxljsqhb0jpi7p1vwqcb00sjs7nzrj7vh2p7mqla";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse pcre ];

  prePatch = ''
    # do not set sticky bit in nix store
    substituteInPlace Makefile --replace 6755 0755
  '';

  preConfigure = "substituteInPlace Makefile --replace /usr/local $out";

  meta = with lib; {
    description = ''A FUSE filesystem intended to be used
      like Apache mod_rewrite'';
    homepage    = "https://github.com/sloonz/rewritefs";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };
}
