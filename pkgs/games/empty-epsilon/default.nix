{ lib, stdenv, fetchFromGitHub, cmake, sfml, libX11, glew, python3 }:

let

  major = "2020";
  minor = "08";
  patch = "07";

  version = "${major}.${minor}.${patch}";

  serious-proton = stdenv.mkDerivation {
    pname = "serious-proton";
    inherit version;

    src = fetchFromGitHub {
      owner = "daid";
      repo = "SeriousProton";
      rev = "EE-${version}";
      sha256 = "1mfizhmwh6xgb5n34l3wrbxm21f7gsvsyacsmnxw9rkz0ya7ch30";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ sfml libX11 ];

    meta = with lib; {
      description = "C++ game engine coded on top of SFML used for EmptyEpsilon";
      homepage = "https://github.com/daid/SeriousProton";
      license = licenses.mit;
      maintainers = with maintainers; [ fpletz ];
      platforms = platforms.linux;
    };
  };

in


stdenv.mkDerivation {
  pname = "empty-epsilon";
  inherit version;

  src = fetchFromGitHub {
    owner = "daid";
    repo = "EmptyEpsilon";
    rev = "EE-${version}";
    sha256 = "0p41wx9yk09xjmfkjpdgi3b2999ps2am3xqwd866q11f6ci7viv5";
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
    homepage = "https://daid.github.io/EmptyEpsilon/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz lheckemann ma27 ];
    platforms = platforms.linux;
  };
}
