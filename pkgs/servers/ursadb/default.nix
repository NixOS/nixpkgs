{ lib, stdenv, fetchFromGitHub, cmake, zeromq, cppzmq }:

stdenv.mkDerivation rec {
  pname = "ursadb";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "ursadb";
    rev = "v${version}";
    hash = "sha256-/EK1CKJ0IR7fkKSpQkONbWcz6uhUoAwK430ljNYsV5U=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace \
        "add_executable(ursadb_test Tests.cpp)" "" \
      --replace \
        "target_link_libraries(ursadb_test ursa)" ""
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ursadb $out/bin/
    cp ursadb_new $out/bin/
    cp ursadb_trim $out/bin/
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zeromq
    cppzmq
  ];

  meta = with lib; {
    homepage = "https://github.com/CERT-Polska/ursadb";
    description = "Trigram database written in C++, suited for malware indexing";
    license = licenses.bsd3;
    maintainers = with maintainers; [ msm ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
