{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "versatile-thermostat-ui-card";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "jmcollin78";
    repo = "versatile-thermostat-ui-card";
    rev = "${version}";
    hash = "sha256-l5GfmK3fAolJvY8q6iX5zjwjW/f6zDOG5vpKsPPR8gs=";
  };

  npmFlags = [ "--legacy-peer-deps" ];
  npmDepsHash = "sha256-PRgt6s+5dGHzn0pnZJDVXBKMXM+4wwYtRTdl0QwA9Dw=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 dist/versatile-thermostat-ui-card.js $out

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/jmcollin78/versatile-thermostat-ui-card/releases/tag/${version}";
    description = "Home Assistant card for the Versatile Thermostat integration";
    homepage = "https://github.com/jmcollin78/versatile-thermostat-ui-card";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pwoelfel ];
  };
}
