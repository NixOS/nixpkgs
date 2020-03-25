{ lib, stdenv, fetchFromGitHub, cmake, sfml, libX11, glew, python3 }:

let

  major = "2020";
  minor = "03";
  patch = "22";

  version = "${major}.${minor}.${patch}";

  serious-proton = stdenv.mkDerivation {
    pname = "serious-proton";
    inherit version;

    src = fetchFromGitHub {
      owner = "daid";
      repo = "SeriousProton";
      rev = "EE-${version}";
      sha256 = "15dk2aij571sdrmpp3p0z1njb60lz0d95x0jgqdxz2q3wqnp5p61";
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


stdenv.mkDerivation {
  pname = "empty-epsilon";
  inherit version;

  src = fetchFromGitHub {
    owner = "daid";
    repo = "EmptyEpsilon";
    rev = "EE-${version}";
    sha256 = "0idapy266mfrmi6dq3si5a8n12m1vvxr6ywbs0fs6sdkbabglc0c";
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
    maintainers = with maintainers; [ fpletz lheckemann ma27 ];
    platforms = platforms.linux;
  };
}
