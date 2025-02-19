{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "versatile-thermostat-ui-card";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "jmcollin78";
    repo = "versatile-thermostat-ui-card";
    rev = "${version}";
    hash = "sha256-JOm0jQysBtKHjAXtWnjbEn7UPSNLHd95TGfP13WH0Ww=";
  };

  npmFlags = [ "--legacy-peer-deps" ];
  npmDepsHash = "sha256-TlJGO0kw3+8ukT1DERp/xDwmeSu0ofP5mqrmXmGcF2M=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 dist/versatile-thermostat-ui-card.js $out

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/jmcollin78/versatile-thermostat-ui-card/releases/tag/${version}";
    description = "Home Assistant card for the Versatile Thermostat integration.";
    homepage = "https://github.com/jmcollin78/versatile-thermostat-ui-card";
    license = licenses.mit;
    maintainers = with maintainers; [ pwoelfel ];
  };
}
