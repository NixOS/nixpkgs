{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "rgxg";
  version = "0.1.2";

  src = fetchurl {
    url = "https://github.com/rgxg/rgxg/releases/download/v${version}/rgxg-${version}.tar.gz";
    sha256 = "554741f95dcc320459875c248e2cc347b99f809d9555c957d763d3d844e917c6";
  };

  outputs = [ "bin" "doc" "man" "dev" "lib" "out" ];

 doInstallCheck = true;
 installCheckTarget = "check";

 postInstallCheck = ''
   $bin/bin/rgxg help >/dev/null
 '';

  meta = with stdenv.lib; {
    description = ''rgxg (ReGular eXpression Generator) is a C library and a command-line tool
    to generate (extended) regular expressions.'';
    license = licenses.zlib;
    maintainers = with maintainers; [ hloeffler ];
    homepage = "https://rgxg.github.io/";
    downloadPage = "https://github.com/rgxg/rgxg/releases";
    inherit version;
  };
}
