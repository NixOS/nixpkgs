{ lib, stdenv, fetchFromGitHub, cmake, libpfm, zlib, pkg-config, python3Packages, which, procps, gdb, capnproto }:

stdenv.mkDerivation rec {
  version = "5.6.0";
  pname = "rr";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "rr";
    rev = version;
    sha256 = "H39HPkAQGubXVQV3jCpH4Pz+7Q9n03PrS70utk7Tt2k=";
  };

  postPatch = ''
    substituteInPlace src/Command.cc --replace '_BSD_SOURCE' '_DEFAULT_SOURCE'
    sed '7i#include <math.h>' -i src/Scheduler.cc
    patchShebangs .
  '';

  # With LTO enabled, linking fails with the following message:
  #
  # src/AddressSpace.cc:1666: undefined reference to `rr_syscall_addr'
  # ld.bfd: bin/rr: hidden symbol `rr_syscall_addr' isn't defined
  # ld.bfd: final link failed: bad value
  # collect2: error: ld returned 1 exit status
  #
  # See also https://github.com/NixOS/nixpkgs/pull/110846
  preConfigure = ''substituteInPlace CMakeLists.txt --replace "-flto" ""'';

  nativeBuildInputs = [ cmake pkg-config which ];
  buildInputs = [
    libpfm zlib python3Packages.python python3Packages.pexpect procps gdb capnproto
  ];
  propagatedBuildInputs = [ gdb ]; # needs GDB to replay programs at runtime
  cmakeFlags = [
    "-DCMAKE_C_FLAGS_RELEASE:STRING="
    "-DCMAKE_CXX_FLAGS_RELEASE:STRING="
    "-Ddisable32bit=ON"
  ];

  # we turn on additional warnings due to hardening
  NIX_CFLAGS_COMPILE = "-Wno-error";

  hardeningDisable = [ "fortify" ];

  # FIXME
  #doCheck = true;

  preCheck = "export HOME=$TMPDIR";

  meta = {
    homepage = "https://rr-project.org/";
    description = "Records nondeterministic executions and debugs them deterministically";
    longDescription = ''
      rr aspires to be your primary debugging tool, replacing -- well,
      enhancing -- gdb. You record a failure once, then debug the
      recording, deterministically, as many times as you want. Every
      time the same execution is replayed.
    '';

    license = with lib.licenses; [ mit bsd2 ];
    maintainers = with lib.maintainers; [ pierron thoughtpolice ];
    platforms = lib.platforms.x86;
  };
}
