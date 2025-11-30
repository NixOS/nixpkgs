{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  jq,
  cmake,
  flex,
  bison,
  gecode,
  mpfr,
  cbc,
  zlib,
}:

let
  gecode_6_3_0 = gecode.overrideAttrs (_: {
    version = "6.3.0";
    src = fetchFromGitHub {
      owner = "gecode";
      repo = "gecode";
      rev = "f7f0d7c273d6844698f01cec8229ebe0b66a016a";
      hash = "sha256-skf2JEtNkRqEwfHb44WjDGedSygxVuqUixskTozi/5k=";
    };
    patches = [ ];
  });
in
let
  gecode = gecode_6_3_0;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "minizinc";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
    rev = finalAttrs.version;
    sha256 = "sha256-eu2yNRESypXWCn8INTjGwwRXTWdGYvah/hc2iqFKQmw=";
  };

  nativeBuildInputs = [
    bison
    cmake
    flex
    jq
  ];

  buildInputs = [
    gecode
    mpfr
    cbc
    zlib
  ];

  postInstall = ''
    mkdir -p $out/share/minizinc/solvers/
    jq \
      '.version = "${gecode.version}"
       | .mznlib = "${gecode}/share/minizinc/gecode/"
       | .executable = "${gecode}/bin/fzn-gecode"' \
       ${./gecode.msc} \
       >$out/share/minizinc/solvers/gecode.msc
  '';

  passthru.tests = {
    simple = callPackage ./simple-test { };
  };

  meta = with lib; {
    homepage = "https://www.minizinc.org/";
    description = "Medium-level constraint modelling language";
    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
