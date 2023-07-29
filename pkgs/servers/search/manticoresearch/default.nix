{ lib
, stdenv
, fetchFromGitHub
, bison
, cmake
, flex
, pkg-config
, boost
, icu
, libstemmer
, mariadb-connector-c
, re2
, nlohmann_json
}:

let
  columnar = stdenv.mkDerivation (finalAttrs: {
    pname = "columnar";
    version = "c18-s6"; # see NEED_COLUMNAR_API/NEED_SECONDARY_API in Manticore's GetColumnar.cmake
    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "columnar";
      rev = finalAttrs.version;
      hash = "sha256-/HGh1Wktb65oXKCjGxMl+8kNwEEfPzGT4UxGoGS4+8c=";
    };
    nativeBuildInputs = [ cmake ];
    cmakeFlags = [ "-DAPI_ONLY=ON" ];
    meta = {
      description = "A column-oriented storage and secondary indexing library";
      homepage = "https://github.com/manticoresoftware/columnar/";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "manticoresearch";
  version = "6.0.4";

  src = fetchFromGitHub {
    owner = "manticoresoftware";
    repo = "manticoresearch";
    rev = finalAttrs.version;
    hash = "sha256-enSK3hlGUtrPVA/qF/AFiDJN8CbaTHCzYadBorZLE+c=";
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
    nlohmann_json
    re2
  ];

  postPatch = ''
    sed -i 's/set ( Boost_USE_STATIC_LIBS ON )/set ( Boost_USE_STATIC_LIBS OFF )/' src/CMakeLists.txt

    # supply our own packages rather than letting manticore download dependencies during build
    sed -i 's/^with_get/with_menu/' CMakeLists.txt
    sed -i 's/include(GetNLJSON)/find_package(nlohmann_json)/' CMakeLists.txt
  '';

  cmakeFlags = [
    "-DWITH_GALERA=0"
    "-DWITH_MYSQL=1"
    "-DMYSQL_INCLUDE_DIR=${mariadb-connector-c.dev}/include/mariadb"
    "-DMYSQL_LIB=${mariadb-connector-c.out}/lib/mariadb/libmysqlclient.a"
  ];

  meta = {
    description = "Easy to use open source fast database for search";
    homepage = "https://manticoresearch.com";
    license = lib.licenses.gpl2;
    mainProgram = "searchd";
    maintainers = [ lib.maintainers.jdelStrother ];
    platforms = lib.platforms.all;
  };
})
