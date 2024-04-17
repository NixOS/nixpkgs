{ stdenv
, lib
, fetchFromGitLab
, cmake
, pkg-config
, libusb1
, libftdi1
}:

stdenv.mkDerivation {
  pname = "fw-ectool";
  version = "0-unstable-2023-12-15";

  src = fetchFromGitLab {
    domain = "gitlab.howett.net";
    owner = "DHowett";
    repo = "ectool";
    rev = "3ebe7b8b713b2ebfe2ce92d48fd8d044276b2879";
    hash = "sha256-s6PrFPAL+XJAENqLw5oJqFmAf11tHOJ8h3F5l3pOlZ4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
    libftdi1
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 src/ectool "$out/bin/ectool"
    runHook postInstall
  '';

  meta = with lib; {
    description = "EC-Tool adjusted for usage with framework embedded controller";
    homepage = "https://gitlab.howett.net/DHowett/ectool";
    license = licenses.bsd3;
    maintainers = [ maintainers.mkg20001 ];
    platforms = platforms.linux;
    mainProgram = "ectool";
  };
}
