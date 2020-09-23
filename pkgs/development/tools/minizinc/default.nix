{ stdenv, fetchFromGitHub, fetchpatch, cmake, flex, bison }:

stdenv.mkDerivation rec {
  pname = "minizinc";
  version = "unstable-2020-09-22";

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
    rev = "d4a286f8c8dae2d9d4c3a3cd43f9252f54c586d3";
    sha256 = "0nni772hw2g6m33ff0j5b5c57gvm6vsibcdv52sndy10897nay86";
  };

  nativeBuildInputs = [ cmake flex bison ];

  meta = with stdenv.lib; {
    homepage = "https://www.minizinc.org/";
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
