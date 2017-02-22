{ stdenv, fetchurl, cmake, makeWrapper
, llvm, clang-unwrapped
, flex
, zlib
, perl, ExporterLite, FileWhich, GetoptTabular, RegexpCommon, TermReadKey
, utillinux
}:

assert stdenv.isLinux -> (utillinux != null);

stdenv.mkDerivation rec {
  name = "creduce-${version}";
  version = "2.6.0";

  src = fetchurl {
    url = "http://embed.cs.utah.edu/creduce/${name}.tar.gz";
    sha256 = "0pf5q0n8vkdcr1wrkxn2jzxv0xkrir13bwmqfw3jpbm3dh2c3b6d";
  };

  buildInputs = [
    # Ensure stdenv's CC is on PATH before clang-unwrapped
    stdenv.cc
    # Actual deps:
    cmake makeWrapper
    llvm clang-unwrapped
    flex zlib
    perl ExporterLite FileWhich GetoptTabular RegexpCommon TermReadKey
  ];

  # On Linux, c-reduce's preferred way to reason about
  # the cpu architecture/topology is to use 'lscpu',
  # so let's make sure it knows where to find it:
  patchPhase = stdenv.lib.optionalString stdenv.isLinux ''
    substituteInPlace creduce/creduce_utils.pm --replace \
      lscpu ${utillinux}/bin/lscpu
  '';


  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/creduce --prefix PERL5LIB : "$PERL5LIB"
  '';

  meta = with stdenv.lib; {
    description = "A C program reducer";
    homepage = "https://embed.cs.utah.edu/creduce";
    # Officially, the license is: https://github.com/csmith-project/creduce/blob/master/COPYING
    license = licenses.ncsa;
    longDescription = ''
      C-Reduce is a tool that takes a large C or C++ program that has a
      property of interest (such as triggering a compiler bug) and
      automatically produces a much smaller C/C++ program that has the same
      property.  It is intended for use by people who discover and report
      bugs in compilers and other tools that process C/C++ code.
    '';
    maintainers = [ maintainers.dtzWill ];
    platforms = platforms.all;
  };
}
