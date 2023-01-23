{ lib
, stdenv
, fetchFromGitLab
, cmake
, pkg-config
, spdlog
, nlohmann_json
, systemd
}:

stdenv.mkDerivation rec {
  pname = "ananicy-cpp";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "ananicy-cpp";
    repo = "ananicy-cpp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-iR7yIIGJbRwu62GIEYi70PjtlKXmkPYqSJtMddspBKA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    spdlog
    nlohmann_json
    systemd
  ];

  cmakeFlags = [
    "-DUSE_EXTERNAL_JSON=ON"
    "-DUSE_EXTERNAL_SPDLOG=ON"
    "-DUSE_EXTERNAL_FMTLIB=ON"
    "-DVERSION=${version}"
  ];

  postInstall = ''
    rm -rf "$out"/include
    rm -rf "$out"/lib/cmake
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/ananicy-cpp/ananicy-cpp";
    description = "Rewrite of ananicy in c++ for lower cpu and memory usage";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
