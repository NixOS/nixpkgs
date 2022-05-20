{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "snazy";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = pname;
    rev = version;
    sha256 = "sha256-SoyGvy1F39kvMLuT9QFXiGEpN0DWS3X9ZDZhFocymCw=";
  };
  cargoSha256 = "sha256-vz2bXmuRWFCx7dH0u2zVJLurtUAQ51ZqWVAcuUrm6d8=";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/snazy --help
    $out/bin/snazy --version | grep "snazy ${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/chmouel/snazy/";
    changelog = "https://github.com/chmouel/snazy/releases/tag/v${version}";
    description = "A snazzy json log viewer";
    longDescription = ''
      Snazy is a simple tool to parse json logs and output them in a nice format
      with nice colors.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
