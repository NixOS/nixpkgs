{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "snazy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = pname;
    rev = version;
    sha256 = "sha256-Pv+vLdbMTbDbdUVQhA07WY+o1PwtCiqdAXCj+UlP/ZQ=";
  };
  cargoSha256 = "sha256-96xgpkkWHsyb3kxEXM5f5jFSjbO+VEmX2uHltGJUPGk=";

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
