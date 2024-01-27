{ lib, stdenv, fetchurl, CoreServices }:

stdenv.mkDerivation rec {
  version = "060102";
  pname = "fondu";

  src = fetchurl {
    url = "http://fondu.sourceforge.net/fondu_src-${version}.tgz";
    sha256 = "152prqad9jszjmm4wwqrq83zk13ypsz09n02nrk1gg0fcxfm7fr2";
  };

  postConfigure = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile --replace /System/Library/Frameworks/CoreServices.framework/CoreServices "-framework CoreServices"
  '';

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  makeFlags = [ "DESTDIR=$(out)" ];

  hardeningDisable = [ "fortify" ];

  meta = {
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
  };
}
