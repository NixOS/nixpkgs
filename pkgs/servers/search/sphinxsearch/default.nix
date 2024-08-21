{ lib, stdenv, fetchurl, pkg-config, expat, libmysqlclient,
  enableXmlpipe2 ? false,
  enableMysql ? true
}:

stdenv.mkDerivation rec {
  pname = "sphinxsearch";
  version = "2.2.11";

  src = fetchurl {
    url = "http://sphinxsearch.com/files/sphinx-${version}-release.tar.gz";
    sha256 = "1aa1mh32y019j8s3sjzn4vwi0xn83dwgl685jnbgh51k16gh6qk6";
  };

  enableParallelBuilding = true;

  configureFlags = [
    "--program-prefix=sphinxsearch-"
    "--enable-id64"
  ] ++ lib.optionals (!enableMysql) [
    "--without-mysql"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals enableMysql [
    libmysqlclient
  ] ++ lib.optionals enableXmlpipe2 [
    expat
  ];

  CXXFLAGS = lib.concatStringsSep " " (lib.optionals stdenv.isDarwin [
    # see upstream bug: http://sphinxsearch.com/bugs/view.php?id=2578
    # workaround for "error: invalid suffix on literal
    "-Wno-reserved-user-defined-literal"
    # workaround for "error: non-constant-expression cannot be narrowed from type 'long' to 'int'"
    "-Wno-c++11-narrowing"
  ]);

  meta = {
    description = "Open source full text search server";
    homepage    = "http://sphinxsearch.com";
    license     = lib.licenses.gpl2Plus;
    platforms   = lib.platforms.all;
    maintainers = with lib.maintainers; [ ederoyd46 valodim ];
  };
}
