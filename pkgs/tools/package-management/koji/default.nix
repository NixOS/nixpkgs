{ stdenv, fetchurl, pythonPackages, python }:

stdenv.mkDerivation rec {
  name = "koji-1.8";

  src = fetchurl {
    url = "https://fedorahosted.org/released/koji/koji-1.8.0.tar.bz2";
    sha256 = "10dph209h4jgajb5jmbjhqy4z4hd22i7s2d93vm3ikdf01i8iwf1";
  };

  propagatedBuildInputs = [ pythonPackages.pycurl python ];

  makeFlags = "DESTDIR=$(out)";

  postInstall = ''
    cp -R $out/nix/store/*/* $out/
    rm -rf $out/nix
  '';

  meta = {
    maintainers = [ stdenv.lib.maintainers.mornfall ];
    platforms = stdenv.lib.platforms.linux;
  };
}
