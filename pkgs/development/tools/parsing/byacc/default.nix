{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "byacc";
  version = "20211224";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/byacc/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/byacc/${pname}-${version}.tgz"
    ];
    sha256 = "sha256-e8QoZ6CV3yGJYYtkSXAWKYgY6I5RP8p5LLWtyaaOv7g=";
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
