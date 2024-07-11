{ lib, stdenv, fetchurl, fetchpatch, cmake, makeWrapper
, llvm, libclang
, flex
, zlib
, perlPackages
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "creduce";
  version = "2.10.0";

  src = fetchurl {
    url = "https://embed.cs.utah.edu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "2xwPEjln8k1iCwQM69UwAb89zwPkAPeFVqL/LhH+oGM=";
  };

  patches = [
    # Port to LLVM 15
    (fetchpatch {
      url = "https://github.com/csmith-project/creduce/commit/e507cca4ccb32585c5692d49b8d907c1051c826c.patch";
      hash = "sha256-jO5E85AvHcjlErbUhzuQDXwQkhQsXklcTMQfWBd09OU=";
    })
    (fetchpatch {
      url = "https://github.com/csmith-project/creduce/commit/8d56bee3e1d2577fc8afd2ecc03b1323d6873404.patch";
      hash = "sha256-dRaBaJAYkvMyxKvfriOcg4D+4i6+6orZ85zws1AFx/s=";
    })
    # Port to LLVM 16
    (fetchpatch {
      url = "https://github.com/csmith-project/creduce/commit/8ab9a69caf13ce24172737e8bfd09de51a1ecb6a.patch";
      hash = "sha256-gPNXxYHnsyUvXmC0CGtsulH2Fu/EMnDE4GdOYc0UbiQ=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "-std=c++11" "-std=c++17"
  ''
  # On Linux, c-reduce's preferred way to reason about
  # the cpu architecture/topology is to use 'lscpu',
  # so let's make sure it knows where to find it:
  + lib.optionalString stdenv.isLinux ''
    substituteInPlace creduce/creduce_utils.pm --replace \
      lscpu ${util-linux}/bin/lscpu
  '';

  nativeBuildInputs = [ cmake makeWrapper llvm.dev ];
  buildInputs = [
    # Ensure stdenv's CC is on PATH before clang-unwrapped
    stdenv.cc
    # Actual deps:
    llvm libclang
    flex zlib
  ] ++ (with perlPackages; [ perl ExporterLite FileWhich GetoptTabular RegexpCommon TermReadKey ]);

  postInstall = ''
    wrapProgram $out/bin/creduce --prefix PERL5LIB : "$PERL5LIB"
  '';

  meta = with lib; {
    description = "C program reducer";
    mainProgram = "creduce";
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
