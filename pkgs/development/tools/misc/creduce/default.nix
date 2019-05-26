{ stdenv, fetchurl, cmake, makeWrapper
, llvm, clang-unwrapped
, flex
, zlib
, perlPackages
, utillinux
}:

stdenv.mkDerivation rec {
  pname = "creduce";
  version = "2.9.0";

  src = fetchurl {
    url = "https://embed.cs.utah.edu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1b833z0g1hich68kzbkpfc26xb8w2phfl5savy8c6ir9ihwy1a8w";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [
    # Ensure stdenv's CC is on PATH before clang-unwrapped
    stdenv.cc
    # Actual deps:
    llvm clang-unwrapped
    flex zlib
  ] ++ (with perlPackages; [ perl ExporterLite FileWhich GetoptTabular RegexpCommon TermReadKey ]);

  # On Linux, c-reduce's preferred way to reason about
  # the cpu architecture/topology is to use 'lscpu',
  # so let's make sure it knows where to find it:
  postPatch = stdenv.lib.optionalString stdenv.isLinux ''
    substituteInPlace creduce/creduce_utils.pm --replace \
      lscpu ${utillinux}/bin/lscpu
  '';


  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/creduce --prefix PERL5LIB : "$PERL5LIB"
  '';

  meta = with stdenv.lib; {
    description = "A C program reducer";
    homepage = https://embed.cs.utah.edu/creduce;
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
