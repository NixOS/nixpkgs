{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "sonos-card";
  version = "10.6.8";

  src = fetchFromGitHub {
    owner = "punxaphil";
    repo = "custom-sonos-card";
    tag = "v${version}";
    hash = "sha256-hs2NU/2m/PpjdX9Te5MnXwPoyYVruJbcCKdD004ARxc=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "npm run lint -- --fix &&" "" \
      --replace-fail "&& bash create-dist-maxi-media-player.sh" ""
  '';

  npmDepsHash = "sha256-dCxu4SKAzEI2sGyZMEMPxmrGA3LE1jppG4VAVq45vSs=";

  installPhase = ''
    runHook preInstall

    install -D dist/custom-sonos-card.js $out/custom-sonos-card.js

    runHook postInstall
  '';

  passthru.entrypoint = "custom-sonos-card.js";

  meta = {
    changelog = "https://github.com/punxaphil/custom-sonos-card/releases/tag/${src.tag}";
    description = "Lovelace card for controlling Sonos speakers in Home Assistant";
    homepage = "https://github.com/punxaphil/custom-sonos-card";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
