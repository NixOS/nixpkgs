{ lib
<<<<<<< HEAD
, clangStdenv
=======
, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitLab
, cmake
, pkg-config
, spdlog
, nlohmann_json
, systemd
<<<<<<< HEAD
, libbpf
, elfutils
, bpftools
, zlib
}:

clangStdenv.mkDerivation rec {
  pname = "ananicy-cpp";
  version = "1.1.1";
=======
}:

stdenv.mkDerivation rec {
  pname = "ananicy-cpp";
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "ananicy-cpp";
    repo = "ananicy-cpp";
    rev = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    sha256 = "sha256-oPinSc00+Z6SxjfTh7DttcXSjsLv1X0NI+O37C8M8GY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    bpftools
=======
    sha256 = "sha256-iR7yIIGJbRwu62GIEYi70PjtlKXmkPYqSJtMddspBKA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    spdlog
    nlohmann_json
    systemd
<<<<<<< HEAD
    libbpf
    elfutils
    zlib
  ];

  # BPF A call to built-in function '__stack_chk_fail' is not supported.
  hardeningDisable = [ "stackprotector" ];

=======
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  cmakeFlags = [
    "-DUSE_EXTERNAL_JSON=ON"
    "-DUSE_EXTERNAL_SPDLOG=ON"
    "-DUSE_EXTERNAL_FMTLIB=ON"
<<<<<<< HEAD
    "-DUSE_BPF_PROC_IMPL=ON"
    "-DBPF_BUILD_LIBBPF=OFF"
    "-DENABLE_SYSTEMD=ON"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
