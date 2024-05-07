{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  pkg-config,
  hostname,
  libusb1,
  libftdi1,
}:

stdenv.mkDerivation {
  pname = "fw-ectool";
  version = "0-unstable-2024-04-24";

  src = fetchFromGitLab {
    owner = "DHowett";
    repo = "ectool";
    rev = "39d64fb0e79e874cfe9877af69158fc2520b1a80";
    hash = "sha256-SHRnyqicFlviBDu3aH+uKVUstVxpIhZV6JSuZOgOwXU=";
    domain = "gitlab.howett.net";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    hostname
  ];
  buildInputs = [
    libusb1
    libftdi1
  ];

  installPhase = ''
    install -D src/ectool $out/bin/ectool
  '';

  meta = with lib; {
    description = "EC-Tool adjusted for usage with framework embedded controller";
    homepage = "https://gitlab.howett.net/DHowett/ectool";
    license = licenses.bsd3;
    maintainers = [
      maintainers.mkg20001
      maintainers.ericthemagician
    ];
    platforms = platforms.linux;
    mainProgram = "ectool";
  };
}
