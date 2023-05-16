<<<<<<< HEAD
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
, testers
, manticoresearch
}:

let
  columnar = stdenv.mkDerivation (finalAttrs: {
    pname = "columnar";
    version = "c21-s10"; # see NEED_COLUMNAR_API/NEED_SECONDARY_API in Manticore's cmake/GetColumnar.cmake
    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "columnar";
      rev = finalAttrs.version;
      hash = "sha256-TGFGFfoyHnPSr2U/9dpqFLUN3Dt2jDQrTF/xxDY4pdE=";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
    nativeBuildInputs = [ cmake ];
    cmakeFlags = [ "-DAPI_ONLY=ON" ];
    meta = {
      description = "A column-oriented storage and secondary indexing library";
      homepage = "https://github.com/manticoresoftware/columnar/";
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
<<<<<<< HEAD
  });
  uni-algo = stdenv.mkDerivation (finalAttrs: {
    pname = "uni-algo";
    version = "0.7.2";
    src = fetchFromGitHub {
      owner = "manticoresoftware";
      repo = "uni-algo";
      rev = "v${finalAttrs.version}";
      hash = "sha256-+V9w4UJ+3KsyZUYht6OEzms60mBHd8FewVc7f21Z9ww=";
    };
    nativeBuildInputs = [ cmake ];
    meta = {
      description = "Unicode Algorithms Implementation for C/C++";
      homepage = "https://github.com/manticoresoftware/uni-algo";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "manticoresearch";
  version = "6.2.0";
=======
  };
in
stdenv.mkDerivation rec {
  pname = "manticoresearch";
  version = "5.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "manticoresoftware";
    repo = "manticoresearch";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-KmBIQa5C71Y/1oa3XiPfmb941QDU2rWo7Bl5QlAo+yA=";
=======
    rev = version;
    sha256 = "sha256-samZYwDYgI9jQ7jcoMlpxulSFwmqyt5bkxG+WZ9eXuk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    nlohmann_json
    uni-algo
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    re2
  ];

  postPatch = ''
    sed -i 's/set ( Boost_USE_STATIC_LIBS ON )/set ( Boost_USE_STATIC_LIBS OFF )/' src/CMakeLists.txt

    # supply our own packages rather than letting manticore download dependencies during build
    sed -i 's/^with_get/with_menu/' CMakeLists.txt
<<<<<<< HEAD
    sed -i 's/get_dep \( nlohmann_json .* \)/find_package(nlohmann_json)/' CMakeLists.txt
    sed -i 's/get_dep \( uni-algo .* \)/find_package(uni-algo)/' CMakeLists.txt
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  cmakeFlags = [
    "-DWITH_GALERA=0"
    "-DWITH_MYSQL=1"
    "-DMYSQL_INCLUDE_DIR=${mariadb-connector-c.dev}/include/mariadb"
    "-DMYSQL_LIB=${mariadb-connector-c.out}/lib/mariadb/libmysqlclient.a"
  ];

<<<<<<< HEAD
  passthru.tests.version = testers.testVersion {
    inherit (finalAttrs) version;
    package = manticoresearch;
    command = "searchd --version";
  };

  meta = {
    description = "Easy to use open source fast database for search";
    homepage = "https://manticoresearch.com";
    changelog = "https://github.com/manticoresoftware/manticoresearch/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2;
    mainProgram = "searchd";
    maintainers = [ lib.maintainers.jdelStrother ];
    platforms = lib.platforms.all;
  };
})
=======
  meta = with lib; {
    description = "Easy to use open source fast database for search";
    homepage = "https://manticoresearch.com";
    license = licenses.gpl2;
    mainProgram = "searchd";
    maintainers = with maintainers; [ jdelStrother ];
    platforms = platforms.all;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
