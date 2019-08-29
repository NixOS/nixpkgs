{ buildGoPackage, stdenv, fetchurl }:

buildGoPackage rec {
  name = "filegive-0.7.4";

  src = fetchurl {
    url = "http://viric.name/soft/filegive/${name}.tar.gz";
    sha256 = "1z3vyqfdp271qa5ah0i6jmn9gh3gb296wcm33sd2zfjqapyh12hy";
  };

  goDeps = ./deps.nix;

  goPackagePath = "viric.name/soft/filegive";

  meta = with stdenv.lib; {
    homepage = http://viric.name/cgi-bin/filegive;
    description = "Easy p2p file sending program";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.viric ];
    platforms = platforms.unix;
  };
}
