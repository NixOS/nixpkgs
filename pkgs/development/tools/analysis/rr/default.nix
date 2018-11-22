{ stdenv, fetchFromGitHub, cmake, libpfm, zlib, pkgconfig, python2Packages, which, procps, gdb, capnproto }:

stdenv.mkDerivation rec {
  version = "5.2.0";
  name = "rr-${version}";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "rr";
    rev = version;
    sha256 = "19jsnm8n2smalx2z60x9d8f6g4kdm7zghwyjfvwcxnslk1vn9dkc";
  };

  postPatch = ''
    substituteInPlace src/Command.cc --replace '_BSD_SOURCE' '_DEFAULT_SOURCE'
    sed '7i#include <math.h>' -i src/Scheduler.cc
    patchShebangs .
  '';

  # TODO: remove this preConfigure hook after 5.2.0 since it is fixed upstream
  # see https://github.com/mozilla/rr/issues/2269
  preConfigure = ''substituteInPlace CMakeLists.txt --replace "std=c++11" "std=c++14"'';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake libpfm zlib python2Packages.python python2Packages.pexpect which procps gdb capnproto
  ];
  cmakeFlags = [
    "-DCMAKE_C_FLAGS_RELEASE:STRING="
    "-DCMAKE_CXX_FLAGS_RELEASE:STRING="
    "-Ddisable32bit=ON"
  ];

  # we turn on additional warnings due to hardening
  NIX_CFLAGS_COMPILE = "-Wno-error";

  hardeningDisable = [ "fortify" ];

  enableParallelBuilding = true;

  # FIXME
  #doCheck = true;

  preCheck = "export HOME=$TMPDIR";

  meta = {
    homepage = https://rr-project.org/;
    description = "Records nondeterministic executions and debugs them deterministically";
    longDescription = ''
      rr aspires to be your primary debugging tool, replacing -- well,
      enhancing -- gdb. You record a failure once, then debug the
      recording, deterministically, as many times as you want. Every
      time the same execution is replayed.
    '';

    license = with stdenv.lib.licenses; [ mit bsd2 ];
    maintainers = with stdenv.lib.maintainers; [ pierron thoughtpolice ];
    platforms = stdenv.lib.platforms.x86;
  };
}
