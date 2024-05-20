{ lib, stdenv, fetchFromGitHub, callPackage, jq, cmake, flex, bison, gecode, mpfr, cbc, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "minizinc";
  version = "2.8.4";

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
    rev = finalAttrs.version;
    sha256 = "sha256-RpqjhjdG8u+gqO5SmKep5JpFhXh5GGX65qA15X+MNA4=";
  };

  nativeBuildInputs = [ bison cmake flex jq ];

  buildInputs = [ gecode mpfr cbc zlib ];

  postInstall = ''
    mkdir -p $out/share/minizinc/solvers/
    jq \
      '.version = "${gecode.version}"
       | .mznlib = "${gecode}/share/gecode/mznlib"
       | .executable = "${gecode}/bin/fzn-gecode"' \
       ${./gecode.msc} \
       >$out/share/minizinc/solvers/gecode.msc
  '';

  passthru.tests = {
    simple = callPackage ./simple-test { };
  };

  meta = with lib; {
    homepage = "https://www.minizinc.org/";
    description = "A medium-level constraint modelling language";
    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.sheenobu ];
  };
})
