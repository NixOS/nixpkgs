{ stdenv, fetchFromGitHub, cmake, libpfm, zlib, pkgconfig, python3Packages, which, procps, gdb, capnproto }:

stdenv.mkDerivation rec {
  version = "5.4.0";
  pname = "rr";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "rr";
    rev = version;
    sha256 = "1sfldgkkmsdyaqa28i5agcykc63gwm3zjihd64g86i852w8al2w6";
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
    cmake libpfm zlib python3Packages.python python3Packages.pexpect which procps gdb capnproto
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

  enableParallelBuilding = true;

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

    license = with stdenv.lib.licenses; [ mit bsd2 ];
    maintainers = with stdenv.lib.maintainers; [ pierron thoughtpolice ];
    platforms = stdenv.lib.platforms.x86;
  };
}
