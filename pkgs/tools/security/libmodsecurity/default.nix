{ lib, stdenv, fetchFromGitHub
, autoreconfHook, bison, flex, pkg-config
, curl, geoip, libmaxminddb, libxml2, lmdb, lua, pcre
, ssdeep, valgrind, yajl
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "libmodsecurity";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "SpiderLabs";
    repo = "ModSecurity";
    rev = "v${version}";
    sha256 = "sha256-V+NBT2YN8qO3Px8zEzSA2ZsjSf1pv8+VlLxYlrpqfGg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook bison flex pkg-config ];
  buildInputs = [ curl geoip libmaxminddb libxml2 lmdb lua pcre ssdeep valgrind yajl ];

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--enable-parser-generation"
    "--with-curl=${curl.dev}"
    "--with-libxml=${libxml2.dev}"
    "--with-lmdb=${lmdb.out}"
    "--with-maxmind=${libmaxminddb}"
    "--with-pcre=${pcre.dev}"
    "--with-ssdeep=${ssdeep}"
  ];

  postPatch = ''
    substituteInPlace build/lmdb.m4 \
      --replace "\''${path}/include/lmdb.h" "${lmdb.dev}/include/lmdb.h" \
      --replace "lmdb_inc_path=\"\''${path}/include\"" "lmdb_inc_path=\"${lmdb.dev}/include\""
    substituteInPlace build/ssdeep.m4 \
      --replace "/usr/local/libfuzzy" "${ssdeep}/lib" \
      --replace "\''${path}/include/fuzzy.h" "${ssdeep}/include/fuzzy.h" \
      --replace "ssdeep_inc_path=\"\''${path}/include\"" "ssdeep_inc_path=\"${ssdeep}/include\""
    substituteInPlace modsecurity.conf-recommended \
      --replace "SecUnicodeMapFile unicode.mapping 20127" "SecUnicodeMapFile $out/share/modsecurity/unicode.mapping 20127"
  '';

  postInstall = ''
    mkdir -p $out/share/modsecurity
    cp ${src}/{AUTHORS,CHANGES,LICENSE,README.md,modsecurity.conf-recommended,unicode.mapping} $out/share/modsecurity
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    nginx-modsecurity = nixosTests.nginx-modsecurity;
  };

  meta = with lib; {
    homepage = "https://github.com/SpiderLabs/ModSecurity";
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
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ izorkin ];
  };
}
