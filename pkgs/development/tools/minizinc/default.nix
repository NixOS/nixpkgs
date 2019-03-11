{ stdenv, fetchFromGitHub, cmake, flex, bison }:
let
  version = "2.2.3";
in
stdenv.mkDerivation {
  name = "minizinc-${version}";

  buildInputs = [ cmake flex bison ];

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
    rev = "3d66971a0cad6edbe796f4dd940229d38e5bfe3d"; # tags on the repo are disappearing: See https://github.com/MiniZinc/libminizinc/issues/257
    sha256 = "1q31y9131aj2lsm34srm8i1s0271qcaaknzvym3r8awynm14saq5";
  };

  meta = with stdenv.lib; {
    homepage = http://www.minizinc.org/;
    description = "MiniZinc is a medium-level constraint modelling language.";

    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';

    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheenobu ];
  };
}

