{ lib, stdenv, fetchFromGitHub, cmake, flex, bison }:
stdenv.mkDerivation rec {
  pname = "minizinc";
  version = "2.7.2";

  nativeBuildInputs = [ cmake flex bison ];

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
    rev = version;
    sha256 = "sha256-XiaLD6tJDn8DTQwknlVd1+xf+DNCiOZ12yn1zugCVxY=";
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
}
