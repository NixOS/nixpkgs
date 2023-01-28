{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, ffmpeg
, poco
}:

stdenv.mkDerivation rec {
  pname = "sanjuuni";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "sanjuuni";
    rev = version;
    sha256 = "sha256-WWDbPwiU4YD8XCMuqLWEGinpHkq2FNJZsz3GyVqjDHQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    poco
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 sanjuuni $out/bin/sanjuuni

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/MCJack123/sanjuuni";
    description = "A command-line tool that converts images and videos into a format that can be displayed in ComputerCraft";
    maintainers = [ maintainers.tomodachi94 ];
    license = licenses.gpl2Plus;
    broken = stdenv.isDarwin;
  };
}
