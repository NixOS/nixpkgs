{ lib
, gcc11Stdenv
, fetchFromGitLab
, makeWrapper
, cmake
, spdlog
, nlohmann_json
, systemd
}:

gcc11Stdenv.mkDerivation rec {
  pname = "ananicy-cpp";
  version = "unstable-2021-10-13";

  src = fetchFromGitLab {
    owner = "ananicy-cpp";
    repo = "ananicy-cpp";
    rev = "6a14fe7353221c89347eddbbcafb35cf5fee4758";
    sha256 = "sha256-V0QPXC17ZD2c4MK3DAkzoPgKOU5V5BjfQKUk7I6f8WM=";
  };

  nativeBuildInputs = [
    makeWrapper
    cmake
  ];

  buildInputs = [
    spdlog
    nlohmann_json
    systemd
  ];

  cmakeFlags = [
    "-DUSE_EXTERNAL_JSON=yON"
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
