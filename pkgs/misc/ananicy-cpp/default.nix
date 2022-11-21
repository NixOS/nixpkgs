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
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "ananicy-cpp";
    repo = "ananicy-cpp";
    rev = "4d263de226de106bf32bdbf9c181a7185ffe5a52";
    sha256 = "sha256-V0QPXC17ZD2c4MK3DAkzoPgKOU5V5BjfQKUk7I6f8WM=";
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
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/ananicy-cpp/ananicy-cpp";
    description = "Rewrite of ananicy in c++ for lower cpu and memory usage";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
