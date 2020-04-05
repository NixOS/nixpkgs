{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "byacc";
  version = "20200330";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/byacc/${pname}-${version}.tgz"
      "https://invisible-mirror.net/archives/byacc/${pname}-${version}.tgz"
    ];
    sha256 = "1c0zyn6v286i09jlc8gx6jyaa5438qyy985rqsd76kb8ibfy56g0";
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
    homepage = "https://invisible-island.net/byacc/byacc.html";
    license = licenses.publicDomain;
    platforms = platforms.unix;
  };
}
