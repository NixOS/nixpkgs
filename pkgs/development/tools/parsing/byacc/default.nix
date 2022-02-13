{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "byacc";
  version = "20220128";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/byacc/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/byacc/${pname}-${version}.tgz"
    ];
    sha256 = "sha256-QsGAXMUpMU5qdjJv4bM+gMcIYqRLAUdNo2Li99stdJw=";
  };

  configureFlags = [
    "--program-transform-name='s,^,b,'"
  ];

  doCheck = true;

  postInstall = ''
    ln -s $out/bin/byacc $out/bin/yacc
  '';

  meta = with lib; {
    description = "Berkeley YACC";
    homepage = "https://invisible-island.net/byacc/byacc.html";
    license = licenses.publicDomain;
    platforms = platforms.unix;
  };
}
