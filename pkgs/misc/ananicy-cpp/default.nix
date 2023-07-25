{ lib
, clangStdenv
, fetchFromGitLab
, cmake
, pkg-config
, spdlog
, nlohmann_json
, systemd
, libbpf
, elfutils
, bpftools
, zlib
}:

clangStdenv.mkDerivation rec {
  pname = "ananicy-cpp";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "ananicy-cpp";
    repo = "ananicy-cpp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-BomtP9KcipBJuZjra/ojRyJi+pgktxGGEdt86N1H9Hc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    bpftools
  ];

  buildInputs = [
    spdlog
    nlohmann_json
    systemd
    libbpf
    elfutils
    zlib
  ];

  # BPF A call to built-in function '__stack_chk_fail' is not supported.
  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = [
    "-DUSE_EXTERNAL_JSON=ON"
    "-DUSE_EXTERNAL_SPDLOG=ON"
    "-DUSE_EXTERNAL_FMTLIB=ON"
    "-DUSE_BPF_PROC_IMPL=ON"
    "-DBPF_BUILD_LIBBPF=OFF"
    "-DENABLE_SYSTEMD=ON"
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
