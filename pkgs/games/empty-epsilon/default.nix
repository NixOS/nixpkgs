{ lib, stdenv, fetchFromGitHub, cmake, sfml, libX11, glew, python3, fetchpatch, applyPatches, glm, meshoptimizer, SDL2, ninja}:

let

  major = "2023";
  minor = "06";
  patch.seriousproton = "17";
  patch.emptyepsilon = "17";

  version.seriousproton = "${major}.${minor}.${patch.seriousproton}";
  version.emptyepsilon = "${major}.${minor}.${patch.emptyepsilon}";
  version.basis-universal = "v1_15_update2";

  basis-universal = fetchFromGitHub {
    owner = "BinomialLLC";
    repo = "basis_universal";
    rev = version.basis-universal;
    sha256 = "sha256-2snzq/SnhWHIgSbUUgh24B6tka7EfkGO+nwKEObRkU4=";
  };

  serious-proton = stdenv.mkDerivation {
    pname = "serious-proton";
    version = version.seriousproton;

    src = fetchFromGitHub {
      owner = "daid";
      repo = "SeriousProton";
      rev = "EE-${version.seriousproton}";
      sha256 = "sha256-5ifYb5dX8ihQmJB1RHyzMsZJeXZ+m27JmA+W+XA/XwI=";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ sfml libX11 glm SDL2 ];

    cmakeFlags = [
      "-DFETCHCONTENT_SOURCE_DIR_BASIS=${basis-universal}"
    ];

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
  version = version.emptyepsilon;

  src = fetchFromGitHub {
    owner = "daid";
    repo = "EmptyEpsilon";
    rev = "EE-${version.emptyepsilon}";
    sha256 = "sha256-zuXbCBlv6URndbB0aA+3bli0cSeUBf3LT/7/jcPITnc=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ serious-proton sfml glew libX11 python3 glm SDL2 ninja ];

  cmakeFlags = [
    "-DSERIOUS_PROTON_DIR=${serious-proton.src}"
    "-DCPACK_PACKAGE_VERSION=${version.emptyepsilon}"
    "-DCPACK_PACKAGE_VERSION_MAJOR=${major}"
    "-DCPACK_PACKAGE_VERSION_MINOR=${minor}"
    "-DCPACK_PACKAGE_VERSION_PATCH=${patch.emptyepsilon}"
    "-DFETCHCONTENT_SOURCE_DIR_BASIS=${basis-universal}"
    "-DFETCHCONTENT_SOURCE_DIR_MESHOPTIMIZER=${meshoptimizer.src}"
    "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
    "-G Ninja"
  ];

  meta = with lib; {
    description = "Open source bridge simulator based on Artemis";
    homepage = "https://daid.github.io/EmptyEpsilon/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz lheckemann ma27 ];
    platforms = platforms.linux;
  };
}
