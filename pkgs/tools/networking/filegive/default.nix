{ buildGoPackage, lib, fetchurl }:

buildGoPackage rec {
  pname = "filegive";
  version = "0.7.4";

  src = fetchurl {
    url = "https://viric.name/soft/filegive/filegive-${version}.tar.gz";
    sha256 = "1z3vyqfdp271qa5ah0i6jmn9gh3gb296wcm33sd2zfjqapyh12hy";
  };

  goDeps = ./deps.nix;

  goPackagePath = "viric.name/soft/filegive";

  meta = with lib; {
    homepage = "https://viric.name/cgi-bin/filegive";
    description = "Easy p2p file sending program";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.viric ];
    platforms = platforms.unix;
  };
}
