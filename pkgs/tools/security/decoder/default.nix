{ lib
, stdenv
, fetchFromGitHub
, openssl
}:

stdenv.mkDerivation rec {
  pname = "decoder";
  version = "unstable-2021-11-20";

  src = fetchFromGitHub {
    owner = "PeterPawn";
    repo = "decoder";
    rev = "da0f826629d4e7b873f9d1a39f24c50ff0a68cd2";
    sha256 = "sha256-1sT1/iwtc2ievmLuNuooy9b14pTs1ZC5noDwzFelk7w=";
  };

  buildInputs = [
    openssl
  ];

  makeFlags = [ "OPENSSL=y" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 src/decoder "$out/bin/decoder"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/PeterPawn/decoder";
    description = ''"secrets" decoding for FRITZ!OS devices'';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
}
