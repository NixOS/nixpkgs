{ lib, stdenv, fetchFromGitHub, fetchurl
, bison, cmake, flex, pkg-config
, boost, icu, libstemmer, mariadb-connector-c, re2
}:
let
  columnar = stdenv.mkDerivation rec {
    pname = "columnar";
    version = "c16-s5"; # see NEED_COLUMNAR_API/NEED_SECONDARY_API in Manticore's GetColumnar.cmake
    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "columnar";
      rev = version;
      sha256 = "sha256-iHB82FeA0rq9eRuDzY+AT/MiaRIGETsnkNPCqKRXgq8=";
    };
    nativeBuildInputs = [ cmake ];
    cmakeFlags = [ "-DAPI_ONLY=ON" ];
    meta = {
      description = "A column-oriented storage and secondary indexing library";
      homepage = "https://github.com/manticoresoftware/columnar/";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  };
in
stdenv.mkDerivation rec {
  pname = "manticoresearch";
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "manticoresoftware";
    repo = "manticoresearch";
    rev = version;
    sha256 = "sha256-samZYwDYgI9jQ7jcoMlpxulSFwmqyt5bkxG+WZ9eXuk=";
  };

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
  ];

  buildInputs = [
    boost
    columnar
    icu.dev
    libstemmer
    mariadb-connector-c
    re2
  ];

  postPatch = ''
    sed -i 's/set ( Boost_USE_STATIC_LIBS ON )/set ( Boost_USE_STATIC_LIBS OFF )/' src/CMakeLists.txt

    # supply our own packages rather than letting manticore download dependencies during build
    sed -i 's/^with_get/with_menu/' CMakeLists.txt
  '';

  cmakeFlags = [
    "-DWITH_GALERA=0"
    "-DWITH_MYSQL=1"
    "-DMYSQL_INCLUDE_DIR=${mariadb-connector-c.dev}/include/mariadb"
    "-DMYSQL_LIB=${mariadb-connector-c.out}/lib/mariadb/libmysqlclient.a"
  ];

  meta = with lib; {
    description = "Easy to use open source fast database for search";
    homepage = "https://manticoresearch.com";
    license = licenses.gpl2;
    mainProgram = "searchd";
    maintainers = with maintainers; [ jdelStrother ];
    platforms = platforms.all;
  };
}
