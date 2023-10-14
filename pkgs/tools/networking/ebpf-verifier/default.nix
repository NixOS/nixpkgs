{ lib
, stdenv
, fetchFromGitHub
, boost
, cmake
, catch2
, pkg-config
, substituteAll
, yaml-cpp
}:

stdenv.mkDerivation {
  pname = "ebpf-verifier";
  version = "unstable-2023-07-15";

  src = fetchFromGitHub {
    owner = "vbpf";
    repo = "ebpf-verifier";
    rev = "de14d3aa3cd2845b621faf32b599766a66e158cf";
    fetchSubmodules = true;
    hash = "sha256-gnxB8ZLbTyIYpd61T57LPKFm1MHufeVEq/qN9pu2Vpk=";
  };

  patches = [
    (substituteAll {
      # We will download them instead of cmake's fetchContent
      src = ./remove-fetchcontent-usage.patch;
      catch2Src = catch2.src;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    boost
    yaml-cpp
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ../check $out/bin/ebpf-verifier

    runHook postInstall
  '';

  meta = with lib; {
    description = "eBPF verifier based on abstract interpretation";
    homepage = "https://github.com/vbpf/ebpf-verifier";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gaelreyrol ];
  };
}
