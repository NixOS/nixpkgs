{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "sonos-card";
  version = "10.6.4";

  src = fetchFromGitHub {
    owner = "punxaphil";
    repo = "custom-sonos-card";
    tag = "v${version}";
    hash = "sha256-GgXkB3XPv0NnUeNGW96QWvgaU6eRn6R7f+MdUG+zT8M=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "npm run lint -- --fix &&" "" \
      --replace-fail "&& bash create-dist-maxi-media-player.sh" ""
  '';

  npmDepsHash = "sha256-FfzcR6Hg2fCbxElz0ard0oTg5IHI6UmXzGBBX8TR4Po=";

  installPhase = ''
    runHook preInstall

    install -D dist/custom-sonos-card.js $out/custom-sonos-card.js

    runHook postInstall
  '';

  passthru.entrypoint = "custom-sonos-card.js";

  meta = {
    description = "Home Assistant custom lovelace sonos card";
    homepage = "https://github.com/punxaphil/custom-sonos-card";
    changelog = "https://github.com/punxaphil/custom-sonos-card/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      SuperSandro2000
    ];
  };
}
