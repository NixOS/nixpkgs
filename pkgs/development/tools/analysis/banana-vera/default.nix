{ lib
, stdenv
, fetchFromGitHub
, cmake
, python310
, tcl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "banana-vera";
  version = "1.3.0-python3.10";

  src = fetchFromGitHub {
    owner = "Epitech";
    repo = "banana-vera";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-1nAKhUltQS1301JNrr0PQQrrf2W9Hj5gk1nbUhN4cXw=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    python310
    python310.pkgs.boost
    tcl
  ];

  cmakeFlags = [
    "-DVERA_LUA=OFF"
    "-DVERA_USE_SYSTEM_BOOST=ON"
    "-DPANDOC=OFF"
  ];

  meta = {
    mainProgram = "vera++";
    description = "A fork of vera using python3.10";
    homepage = "https://github.com/Epitech/banana-vera";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
