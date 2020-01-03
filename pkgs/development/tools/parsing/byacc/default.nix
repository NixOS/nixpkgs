{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "byacc";
  version = "20191119";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/byacc/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/byacc/${pname}-${version}.tgz"
    ];
    sha256 = "0ch8y9g7b3lnw1r76p65gvdnbpwd60d4pghgadid122fcq7566p2";
  };

  configureFlags = [
    "--program-transform-name='s,^,b,'"
  ];

  doCheck = true;

  postInstall = ''
    ln -s $out/bin/byacc $out/bin/yacc
  '';

  meta = with stdenv.lib; {
    description = "Berkeley YACC";
    homepage = https://invisible-island.net/byacc/byacc.html;
    license = licenses.publicDomain;
    platforms = platforms.unix;
  };
}
