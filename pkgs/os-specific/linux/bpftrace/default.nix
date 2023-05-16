<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, fetchpatch
, llvmPackages, elfutils, bcc
, libbpf, libbfd, libopcodes
, cereal, asciidoctor
, cmake, pkg-config, flex, bison
, util-linux
, nixosTests
=======
{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, flex, bison
, llvmPackages, elfutils
, libbfd, libbpf, libopcodes, bcc
, cereal, asciidoctor
, nixosTests
, util-linux
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "bpftrace";
<<<<<<< HEAD
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "iovisor";
    repo  = "bpftrace";
    rev   = "v${version}";
    hash  = "sha256-hwxArrTdjJoab7Twf57PRmRhghV/9EcjRXI0lKRQC0k=";
  };


  buildInputs = with llvmPackages; [
    llvm libclang
    elfutils bcc
    libbpf libbfd libopcodes
    cereal asciidoctor
  ];

  nativeBuildInputs = [
    cmake pkg-config flex bison
    llvmPackages.llvm.dev
    util-linux
  ];
=======
  version = "0.17.1";

  src = fetchFromGitHub {
    owner  = "iovisor";
    repo   = "bpftrace";
    rev    = "v${version}";
    sha256 = "sha256-dEchHXZPWc+/Dui6P65EqxB8O/M7F47PZVsKSp80oXE=";
  };

  buildInputs = with llvmPackages;
    [ llvm libclang
      elfutils bcc
      libbpf libbfd libopcodes
      cereal asciidoctor
    ];

  nativeBuildInputs = [ cmake pkg-config flex bison llvmPackages.llvm.dev util-linux ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # tests aren't built, due to gtest shenanigans. see:
  #
  #     https://github.com/iovisor/bpftrace/issues/161#issuecomment-453606728
  #     https://github.com/iovisor/bpftrace/pull/363
  #
<<<<<<< HEAD
  cmakeFlags = [
    "-DBUILD_TESTING=FALSE"
    "-DLIBBCC_INCLUDE_DIRS=${bcc}/include"
    "-DINSTALL_TOOL_DOCS=OFF"
    "-DUSE_SYSTEM_BPF_BCC=ON"
  ];
=======
  cmakeFlags =
    [ "-DBUILD_TESTING=FALSE"
      "-DLIBBCC_INCLUDE_DIRS=${bcc}/include"
      "-DINSTALL_TOOL_DOCS=off"
    ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Pull BPF scripts into $PATH (next to their bcc program equivalents), but do
  # not move them to keep `${pkgs.bpftrace}/share/bpftrace/tools/...` working.
  postInstall = ''
    ln -s $out/share/bpftrace/tools/*.bt $out/bin/
  '';

  outputs = [ "out" "man" ];

  passthru.tests = {
    bpf = nixosTests.bpf;
  };

  meta = with lib; {
    description = "High-level tracing language for Linux eBPF";
    homepage    = "https://github.com/iovisor/bpftrace";
<<<<<<< HEAD
    changelog   = "https://github.com/iovisor/bpftrace/releases/tag/v${version}";
    mainProgram = "bpftrace";
    license     = licenses.asl20;
    maintainers = with maintainers; [ rvl thoughtpolice martinetd mfrw ];
=======
    license     = licenses.asl20;
    maintainers = with maintainers; [ rvl thoughtpolice martinetd ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
