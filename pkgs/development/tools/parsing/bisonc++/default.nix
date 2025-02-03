{lib, stdenv, fetchurl, fetchFromGitLab
, yodl, icmake, flexcpp, bobcat
}:
stdenv.mkDerivation rec {
  pname = "bisonc++";
  version = "6.04.00";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "fbb-git";
    repo = "bisoncpp";
    rev = "6.04.00";
    hash = "sha256:0aa9bij4g08ilsk6cgrbgi03vyhqr9fn6j2164sjin93m63212wl";
  };

  buildInputs = [ bobcat ];

  nativeBuildInputs = [ yodl icmake flexcpp ];

  setSourceRoot = ''
    sourceRoot="$(echo */bisonc++)"
  '';

  gpl = fetchurl {
    url = "https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt";
    sha256 = "sha256:0hq6i0dm4420825fdm0lnnppbil6z67ls67n5kgjcd912dszjxw1";
  };

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs .
    for file in $(find documentation -type f); do
      substituteInPlace "$file" --replace /usr/share/common-licenses/GPL ${gpl}
      substituteInPlace "$file" --replace /usr $out
    done
  '';

  buildPhase = ''
    ./build program
    ./build man
    ./build manual
  '';

  installPhase = ''
    ./build install x
  '';

  meta = with lib; {
    description = "Parser generator like bison, but it generates C++ code";
    mainProgram = "bisonc++";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "https://fbb-git.gitlab.io/bisoncpp/";
  };
}
