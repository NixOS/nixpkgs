{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, pcre
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pplatex";
  version = "unstable-2023-04-18";

  src = fetchFromGitHub {
    owner = "stefanhepp";
    repo = "pplatex";
    rev = "8487b00b25127d9a4883e878000f4be6f89d56d5";
    sha256 = "sha256-wPPJBn/UfmTWsD5JOg6po83Qn4qlpwgsPUV3iJzw5KU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pcre
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 src/pplatex "$out"/bin/pplatex
    runHook postInstall
  '';

  meta = with lib; {
    description =
      "A tool to reformat the output of latex and friends into readable messages";
    homepage = "https://github.com/stefanhepp/pplatex";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.srgom maintainers.doronbehar ];
    platforms = platforms.unix;
  };
})
