<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, callPackage, jq, cmake, flex, bison, gecode, mpfr, cbc, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "minizinc";
  version = "2.7.6";
=======
{ lib, stdenv, fetchFromGitHub, cmake, flex, bison }:
stdenv.mkDerivation rec {
  pname = "minizinc";
  version = "2.7.3";

  nativeBuildInputs = [ cmake flex bison ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
<<<<<<< HEAD
    rev = finalAttrs.version;
    sha256 = "sha256-1+bFF79lYt5RAx5gfNg7J3iB7ExxNgFUmBIcg6/hfQs=";
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
=======
    rev = version;
    sha256 = "sha256-qDAFXyWEwdei1jBHb5ONgivlp2ftMNfBbq8a/Ibh2BM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    homepage = "https://www.minizinc.org/";
    description = "A medium-level constraint modelling language";
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.sheenobu ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
