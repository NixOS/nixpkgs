{ stdenv, fetchFromGitHub, bobcat, icmake, yodl }:

stdenv.mkDerivation rec {
  name = "flexc++-${version}";
  version = "2.04.00";

  src = fetchFromGitHub {
    sha256 = "0fz9gxpc491cngj9z9y059vbl65ng48c4nw9k3sl983zfnqfy26y";
    rev = version;
    repo = "flexcpp";
    owner = "fbb-git";
  };

  sourceRoot = "flexcpp-${version}-src/flexc++";

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

  meta = with stdenv.lib; {
    description = "C++ tool for generating lexical scanners";
    longDescription = ''
      Flexc++ was designed after `flex'. Flexc++ offers a cleaner class design
      and requires simpler specification files than offered by flex's C++
      option.
    '';
    homepage = https://fbb-git.github.io/flexcpp/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
