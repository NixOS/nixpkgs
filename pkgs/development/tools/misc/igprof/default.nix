{lib, stdenv, fetchFromGitHub, libunwind, cmake, pcre, gdb}:

stdenv.mkDerivation rec {
  version = "5.9.16";
  pname = "igprof";

  src = fetchFromGitHub {
    owner = "igprof";
    repo = "igprof";
    rev = "v${version}";
    sha256 = "0rx3mv8zdh9bmcpfbzkib3d52skzfr8600gh5gv21wcsh50jnifx";
  };

  postPatch = ''
    substituteInPlace src/igprof --replace libigprof.so $out/lib/libigprof.so
    '';

  buildInputs = [libunwind gdb pcre];
  nativeBuildInputs = [cmake];
  CXXFLAGS = ["-fPIC" "-O2" "-w" "-fpermissive"];

  meta = {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "The Ignominous Profiler";

    longDescription = ''
      IgProf is a fast and light weight profiler. It correctly handles
      dynamically loaded shared libraries, threads and sub-processes started by
      the application.  We have used it routinely with large C++ applications
      consisting of many hundreds of shared libraries and thousands of symbols
      from millions of source lines of code. It requires no special privileges
      to run. The performance reports provide full navigable call stacks and
      can be customised by applying filters. Results from any number of
      profiling runs can be included. This means you can both dig into the
      details and see the big picture from combined workloads.
    '';

    license = lib.licenses.gpl2;

    homepage = "https://igprof.org/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ktf ];
  };
}
