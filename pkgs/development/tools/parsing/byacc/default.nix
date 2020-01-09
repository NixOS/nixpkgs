{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "byacc";
  version = "20191125";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/byacc/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/byacc/${pname}-${version}.tgz"
    ];
    sha256 = "1phw8410ly3msv03dmjfi8xkmrl1lrrk928fp1489amg6sz2w707";
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
