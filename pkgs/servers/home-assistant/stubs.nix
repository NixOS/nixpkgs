{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  home-assistant,
  python,
}:

buildPythonPackage rec {
  pname = "homeassistant-stubs";
<<<<<<< HEAD
  version = "2025.12.5";
=======
  version = "2025.11.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = python.version != home-assistant.python.version;

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = "homeassistant-stubs";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-c2Vr5S7WxaT0q4/Zc3yJmSU4ErhogCBKOISj1WVXflY=";
=======
    hash = "sha256-Cl5wRdYGVGtDTsnlU5poHJA3F8wxh1e3Rb1Zhmfc2CI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatchling
    hatch-vcs
    home-assistant
  ];

  postPatch = ''
    # Relax constraint to year and month
    substituteInPlace pyproject.toml --replace-fail \
      'homeassistant==${version}' \
      'homeassistant~=${lib.versions.majorMinor home-assistant.version}'
  '';

  pythonImportsCheck = [
    "homeassistant-stubs"
  ];

  doCheck = false;

  meta = {
    description = "Typing stubs for Home Assistant Core";
    homepage = "https://github.com/KapJI/homeassistant-stubs";
    changelog = "https://github.com/KapJI/homeassistant-stubs/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    teams = [ lib.teams.home-assistant ];
  };
}
