{ lib, stdenv, fetchFromGitHub, cmake, installShellFiles, openssl }:

stdenv.mkDerivation rec {
  pname = "flashmq";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "halfgaar";
    repo = "FlashMQ";
    rev = "v${version}";
    hash = "sha256-DcxwwUNpnMeK8A3LuyfrWAMCng0yIcX9bKxNGY0uDSo=";
  };

  nativeBuildInputs = [ cmake installShellFiles ];

  buildInputs = [ openssl ];

  installPhase = ''
    runHook preInstall

    install -Dm755 flashmq -t $out/bin
    installManPage $src/man/*.{1,5}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast light-weight MQTT broker/server";
    homepage = "https://www.flashmq.org/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
