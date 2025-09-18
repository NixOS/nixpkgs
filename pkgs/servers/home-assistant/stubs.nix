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
  version = "2025.9.3";
  pyproject = true;

  disabled = python.version != home-assistant.python.version;

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = "homeassistant-stubs";
    tag = version;
    hash = "sha256-BaPs77BK5tq+yd15O9oZgvE0R0WM61eMZpMmKivhaPI=";
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
