{ lib, stdenv, fetchFromGitHub, bobcat, icmake, yodl }:

stdenv.mkDerivation rec {
  pname = "flexc++";
  version = "2.05.00";

  src = fetchFromGitHub {
    sha256 = "0s25d9jsfsqvm34rwf48cxwz23aq1zja3cqlzfz3z33p29wwazwz";
    rev = version;
    repo = "flexcpp";
    owner = "fbb-git";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */flexc++)
  '';

  buildInputs = [ bobcat ];
  nativeBuildInputs = [ icmake yodl ];

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs .
  '';

  buildPhase = ''
    ./build man
    ./build manual
    ./build program
  '';

  installPhase = ''
    ./build install x
  '';

  meta = with lib; {
    description = "C++ tool for generating lexical scanners";
    mainProgram = "flexc++";
    longDescription = ''
      Flexc++ was designed after `flex'. Flexc++ offers a cleaner class design
      and requires simpler specification files than offered by flex's C++
      option.
    '';
    homepage = "https://fbb-git.github.io/flexcpp/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
