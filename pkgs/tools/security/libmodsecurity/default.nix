{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, doxygen, perl, valgrind
, curl, geoip, libxml2, lmdb, lua, pcre, yajl }:

stdenv.mkDerivation rec {
  name = "libmodsecurity-${version}";
  version = "3.0.0-2017-11-17";

  src = fetchFromGitHub {
    owner = "SpiderLabs";
    repo = "ModSecurity";
    fetchSubmodules = true;
    rev = "81e1cdced3c0266d4b02a68e5f99c30a9c992303";
    sha256 = "120bpvjq6ws2lv4vw98rx2s0c9yn0pfhlaphlgfv2rxqm3q7yhrr";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ doxygen perl valgrind curl geoip libxml2 lmdb lua pcre yajl];

  configureFlags = [
    "--enable-static"
    "--with-curl=${curl.dev}"
    "--with-libxml=${libxml2.dev}"
    "--with-pcre=${pcre.dev}"
    "--with-yajl=${yajl}"
  ];

  meta = with stdenv.lib; {
    description = ''
      Libmodsecurity is one component of the ModSecurity v3 project.
    '';
    longDescription = ''
      Libmodsecurity is one component of the ModSecurity v3 project. The
      library codebase serves as an interface to ModSecurity Connectors taking
      in web traffic and applying traditional ModSecurity processing. In
      general, it provides the capability to load/interpret rules written in
      the ModSecurity SecRules format and apply them to HTTP content provided
      by your application via Connectors.
    '';
    homepage = https://modsecurity.org/;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ izorkin ];
  };
}

