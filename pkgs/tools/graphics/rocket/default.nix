{ stdenv, fetchFromGitHub, qmake, qtbase }:

stdenv.mkDerivation rec {
  name = "rocket-${version}";
  version = "2018-06-09";

  src = fetchFromGitHub {
    owner = "rocket";
    repo = "rocket";
    rev = "7bc1e9826cad5dbc63e56371c6aa1798b2a7b50b";
    sha256 = "13bdg2dc6ypk17sz39spqdlb3wai2y085bdb36pls2as2nf22drp";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase ];

  configurePhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp -r editor/editor $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A tool for synchronizing music and visuals in demoscene productions";
    homepage = "https://github.com/rocket/rocket";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = [ maintainers.dezgeg ];
  };
}
