{ stdenv, fetchFromGitHub, bobcat, icmake, yodl }:

stdenv.mkDerivation rec {
  name = "flexc++-${version}";
  version = "2.03.00";

  src = fetchFromGitHub {
    sha256 = "1knb5h6l71n5zi9xzml5f6v7wspbk7vrcaiy2div8bnj7na3z717";
    rev = version;
    repo = "flexcpp";
    owner = "fbb-git";
  };

  sourceRoot = "flexcpp-${version}-src/flexc++";

  buildInputs = [ bobcat ];
  nativeBuildInputs = [ icmake yodl ];

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs ./build
  '';

  buildPhase = ''
    ./build man
    ./build manual
    ./build program
  '';

  installPhase = ''
    ./build install man
    ./build install manual
    ./build install program
    ./build install skel
    ./build install std
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
