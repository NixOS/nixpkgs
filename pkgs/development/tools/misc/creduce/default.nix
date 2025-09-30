{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  llvm,
  libclang,
  flex,
  zlib,
  perlPackages,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "creduce";
  version = "2.10.0-unstable-2024-06-01";

  src = fetchFromGitHub {
    owner = "csmith-project";
    repo = "creduce";
    rev = "31e855e290970cba0286e5032971509c0e7c0a80";
    hash = "sha256-RbxFqZegsCxnUaIIA5OfTzx1wflCPeF+enQt90VwMgA=";
  };

  postPatch =
    # On Linux, c-reduce's preferred way to reason about
    # the cpu architecture/topology is to use 'lscpu',
    # so let's make sure it knows where to find it:
    lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace creduce/creduce_utils.pm --replace \
        lscpu ${util-linux}/bin/lscpu
    '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    llvm.dev
  ];
  buildInputs = [
    # Ensure stdenv's CC is on PATH before clang-unwrapped
    stdenv.cc
    # Actual deps:
    llvm
    libclang
    flex
    zlib
  ]
  ++ (with perlPackages; [
    perl
    ExporterLite
    FileWhich
    GetoptTabular
    RegexpCommon
    TermReadKey
  ]);

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
    maintainers = [ ];
    platforms = platforms.all;
  };
}
