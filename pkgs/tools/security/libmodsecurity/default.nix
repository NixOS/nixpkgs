{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, doxygen, perl, valgrind
, curl, geoip, libxml2, lmdb, lua, pcre, yajl }:

stdenv.mkDerivation rec {
  pname = "libmodsecurity";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "SpiderLabs";
    repo = "ModSecurity";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "00g2407g2679zv73q67zd50z0f1g1ij734ssv2pp77z4chn5dzib";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig doxygen ];

  buildInputs = [ perl valgrind curl geoip libxml2 lmdb lua pcre yajl ];

  configureFlags = [
    "--enable-static"
    "--with-curl=${curl.dev}"
    "--with-libxml=${libxml2.dev}"
    "--with-pcre=${pcre.dev}"
    "--with-yajl=${yajl}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = ''
      ModSecurity v3 library component.
    '';
    longDescription = ''
      Libmodsecurity is one component of the ModSecurity v3 project. The
      library codebase serves as an interface to ModSecurity Connectors taking
      in web traffic and applying traditional ModSecurity processing. In
      general, it provides the capability to load/interpret rules written in
      the ModSecurity SecRules format and apply them to HTTP content provided
      by your application via Connectors.
    '';
    homepage = "https://modsecurity.org/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ izorkin ];
  };
}
