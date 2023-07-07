{ lib, stdenv, fetchFromGitHub, cmake, sfml, libX11, glew, python3, fetchpatch, applyPatches, glm}:

let

  major = "2021";
  minor = "06";
  patch.seriousproton = "23";
  patch.emptyepsilon = "23";

  version.seriousproton = "${major}.${minor}.${patch.seriousproton}";
  version.emptyepsilon = "${major}.${minor}.${patch.emptyepsilon}";

  serious-proton = stdenv.mkDerivation {
    pname = "serious-proton";
    version = version.seriousproton;

    src = applyPatches {
      src = fetchFromGitHub {
        owner = "daid";
        repo = "SeriousProton";
        rev = "EE-${version.seriousproton}";
        sha256 = "sha256-02cHHWKoe99257qLgxtMjeXnhi0UYajh4v87B57felM=";
      };

      patches = [
        # Various CMake fixes for `json11`. Can be removed on the next release.
        (fetchpatch {
          url = "https://github.com/daid/SeriousProton/commit/adbba45fd9ae5e020e43e5d7f9326f1355391209.patch";
          sha256 = "sha256-gMTpIGPGCREmZ/ZxvEc7RVsVUxWXbu2BPUCE3A62sCI=";
        })

        # Simplified variant of
        # * https://github.com/daid/SeriousProton/commit/0d1ac45b738195db5e2785531db713328f547e60
        # * https://github.com/daid/SeriousProton/commit/32509f2db91a58b9528aeb1bb505e9426b52b825
        #
        # To fix configure errors when building EmptyEpsilon, can be removed on the next release.
        ./0001-bundle-system-glm-in-seriousproton.patch
      ];
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ sfml libX11 glm ];

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
    sha256 = "sha256-dc/Ic1/DULTQO6y9xSop2HxFvUh4kN57oSF/HBmbmF4=";
  };

  patches = [
    # Various CMake fixes that can be removed when upgrading to the next release.
    (fetchpatch {
      url = "https://github.com/daid/EmptyEpsilon/commit/ee0cd42bfe5fd20b8339e8e02eb7f69766168d57.patch";
      sha256 = "sha256-8dXtl/izfzqbwHtjuugjH34vYP+d4AobqZhxL2GXTzw=";
    })
    (fetchpatch {
      url = "https://github.com/daid/EmptyEpsilon/commit/69d93e6acdae3259755924f9d35e7e5ae949d377.patch";
      sha256 = "sha256-30AGo4mi73GrW9GNS3vF3mTOS7J5/41LvjOzNjeFhOg=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ serious-proton sfml glew libX11 python3 glm ];

  cmakeFlags = [
    "-DSERIOUS_PROTON_DIR=${serious-proton.src}"
    "-DCPACK_PACKAGE_VERSION=${version.emptyepsilon}"
    "-DCPACK_PACKAGE_VERSION_MAJOR=${major}"
    "-DCPACK_PACKAGE_VERSION_MINOR=${minor}"
    "-DCPACK_PACKAGE_VERSION_PATCH=${patch.emptyepsilon}"
  ];

  meta = with lib; {
    description = "Open source bridge simulator based on Artemis";
    homepage = "https://daid.github.io/EmptyEpsilon/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz lheckemann ma27 ];
    platforms = platforms.linux;
  };
}
