{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "byacc";
  version = "20190617";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/byacc/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/byacc/${pname}-${version}.tgz"
    ];
    sha256 = "13ai0az00c86s4k94cpgh48nf5dfccpvccpw635z42wjgcb6hy7q";
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
