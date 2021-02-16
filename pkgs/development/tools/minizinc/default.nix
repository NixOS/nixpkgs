{ lib, stdenv, fetchFromGitHub, cmake, flex, bison }:
let
  version = "2.5.3";
in
stdenv.mkDerivation {
  pname = "minizinc";
  inherit version;

  nativeBuildInputs = [ cmake flex bison ];

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
    rev = version;
    sha256 = "1kc65sxkc64pr560qaaznc44jnlvq7pbpzwijad410lpcnna5byg";
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
