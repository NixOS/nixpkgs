{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "byacc";
  version = "20210520";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/byacc/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/byacc/${pname}-${version}.tgz"
    ];
    sha256 = "sha256-19MdrnLLlzSC73+XVgmuQBzMEu4/sWi2emlSbGCv5D4=";
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
