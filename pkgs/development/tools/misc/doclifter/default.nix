{lib, stdenv, fetchurl, python3}:

stdenv.mkDerivation rec {
  pname = "doclifter";
  version = "2.20";
  src = fetchurl {
    url = "http://www.catb.org/~esr/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-BEuMbICJ8TD3+VjUr8rmhss7XlPNjxSy1P0SkmKLPsc=";
  };
  buildInputs = [ python3 ];

  strictDeps = true;

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp manlifter $out/bin
    cp manlifter.1 $out/share/man/man1
  '';

  meta = {
    description = "Lift documents in nroff markups to XML-DocBook";
    homepage = "http://www.catb.org/esr/doclifter";
    license = "BSD";
    platforms = lib.platforms.unix;
  };
}
