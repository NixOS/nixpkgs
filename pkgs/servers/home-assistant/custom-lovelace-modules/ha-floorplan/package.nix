{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "floorplan";
  version = "1.0.44";

  src = fetchFromGitHub {
    owner = "ExperienceLovelace";
    repo = "ha-floorplan";
    rev = "refs/tags/${version}";
    hash = "sha256-ajEA47H9nFXVcuvhwkDsxc5YYQWMsUXqHQ3t6tuAaxc=";
  };

  npmDepsHash = "sha256-/6H3XMraD7/usZBwmQaCDpV2n1Eed+U+G0f2YnjyWgk=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R dist/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Floorplan for Home Assistant";
    longDescription = ''
      Bring new life to Home Assistant. By mapping entities to a SVG-object,
      you're able to control devices, show states, calling services - and much
      more. Add custom styling on top, to visualize whatever you can think of.
      Your imagination just became the new limit.
    '';
    homepage = "https://github.com/ExperienceLovelace/ha-floorplan";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    license = lib.licenses.asl20;
  };
}
