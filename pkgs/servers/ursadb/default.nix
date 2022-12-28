{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "ursadb";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "ursadb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JssL1Yd+2CPy9fDPJnstiRucdy6TyUdb0Q6xa160CLM=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "add_executable(ursadb_test src/Tests.cpp)" "" \
      --replace "target_link_libraries(ursadb_test ursa)" "" \
      --replace "target_enable_ipo(ursadb_test)" "" \
      --replace "target_clangformat_setup(ursadb_test)" "" \
      --replace 'target_include_directories(ursadb_test PUBLIC ${"$"}{CMAKE_SOURCE_DIR})' "" \
      --replace "ursadb_test" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    homepage = "https://github.com/CERT-Polska/ursadb";
    description = "Trigram database written in C++, suited for malware indexing";
    license = licenses.bsd3;
    maintainers = with maintainers; [ msm ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
})
