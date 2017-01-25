{ stdenv, fetchFromGitHub, cmake, flex, bison }:
let
  version = "2.0.14";
in
stdenv.mkDerivation {
  name = "minizinc-${version}";

  buildInputs = [ cmake flex bison ];

  src = fetchFromGitHub {
    rev = "${version}";
    owner = "MiniZinc";
    repo = "libminizinc";
    sha256 = "02wy91nv79lrvvhhimcxp7sqz5wd457n1n68zl7qcsm5vfn1hm4q";
  };

  # meta is all the information about the package..
  meta = with stdenv.lib; {
    homepage = "http://www.minizinc.org/";
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

