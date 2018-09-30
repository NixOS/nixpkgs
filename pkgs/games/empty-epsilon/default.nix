{ lib, stdenv, fetchFromGitHub, cmake, sfml, libX11, glew, python3 }:

let

  major = "2018"
  minor = "02"
  patch = "15"

  version = "${major}.${minor}.${patch}";

  serious-proton = stdenv.mkDerivation rec {
    name = "serious-proton-${version}";
    inherit version;

    src = fetchFromGitHub {
      owner = "daid";
      repo = "SeriousProton";
      rev = "EE-${version}";
      sha256 = "0b4n4pn7x3y63i9y15f8983zlpdvmx7151iph1lcc49j3hmpd0gy";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ sfml libX11 ];

    meta = with lib; {
      description = "C++ game engine coded on top of SFML used for EmptyEpsilon";
      homepage = https://github.com/daid/SeriousProton;
      license = licenses.mit;
      maintainers = with maintainers; [ fpletz ];
      platforms = platforms.linux;
    };
  };

in


stdenv.mkDerivation rec {
  name = "empty-epsilon-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "daid";
    repo = "EmptyEpsilon";
    rev = "EE-${version}";
    sha256 = "1by0wrw00frrlcs1kd003zkmfkwa1pnbnva2qn8km3xnl9chf11d";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ serious-proton sfml glew libX11 python3 ];

  cmakeFlags = [
    "-DSERIOUS_PROTON_DIR=${serious-proton.src}"
    "-DCPACK_PACKAGE_VERSION=${version}"
    "-DCPACK_PACKAGE_VERSION_MAJOR=${major}"
    "-DCPACK_PACKAGE_VERSION_MINOR=${minor}"
    "-DCPACK_PACKAGE_VERSION_PATCH=${patch}"
  ];

  meta = with lib; {
    description = "Open source bridge simulator based on Artemis";
    homepage = https://daid.github.io/EmptyEpsilon/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
