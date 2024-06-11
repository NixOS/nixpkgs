{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, which, makeWrapper
, libpfm, zlib, python3Packages, procps, gdb, capnproto
}:

stdenv.mkDerivation rec {
  version = "5.8.0";
  pname = "rr";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "rr";
    rev = version;
    hash = "sha256-FudAAkWIe6gv4NYFoe9E0hlgTM70lymBE5Fw/vbehps=";
  };

  patches = [ ];

  postPatch = ''
    substituteInPlace src/Command.cc --replace '_BSD_SOURCE' '_DEFAULT_SOURCE'
    sed '7i#include <math.h>' -i src/Scheduler.cc
    sed '1i#include <ctime>' -i src/test-monitor/test-monitor.cc
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

  nativeBuildInputs = [ cmake pkg-config which makeWrapper ];
  buildInputs = [
    libpfm zlib python3Packages.python python3Packages.pexpect procps gdb capnproto
  ];
  cmakeFlags = [
    "-Ddisable32bit=ON"
  ];

  # we turn on additional warnings due to hardening
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  hardeningDisable = [ "fortify" ];

  # FIXME
  doCheck = false;

  preCheck = "export HOME=$TMPDIR";

  # needs GDB to replay programs at runtime
  preFixup = ''
    wrapProgram "$out/bin/rr" \
      --prefix PATH ":" "${lib.makeBinPath [
        gdb
      ]}";
  '';

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
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
  };
}
