{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "byacc-${version}";
  version = "20180609";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/byacc/${name}.tgz"
      "https://invisible-mirror.net/archives/byacc/${name}.tgz"
    ];
    sha256 = "173l9yai5yndbyn8nzdl6q11wv4x959bd0w392i82nfsqcz0pfsv";
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
