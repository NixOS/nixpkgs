{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "snazy";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = pname;
    rev = version;
    sha256 = "sha256-kUoML6UUgZLOBCbakj1CJeRSt268rv2ymAdvPkcn8R4=";
  };
  cargoSha256 = "sha256-MPfzC5iEE8GficLUaGaBy5usZzYoreYsdadoiiRoVQI=";

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
