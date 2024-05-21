{ lib
, buildPythonPackage
, fetchFromGitHub
, nix-update-script
, pyyaml
, setuptools
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "snap-helpers";
  version = "0.4.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "albertodonato";
    repo = "snap-helpers";
    rev = "refs/tags/${version}";
    hash = "sha256-7JBvrD4WNOcFSVx3xauk4JgiVGKWuUEdUMRlH7mudE4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyyaml
  ];

  pythonImportsCheck = [
    "snaphelpers"
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interact with snap configuration and properties from inside a snap.";
    homepage = "https://github.com/albertodonato/snap-helpers";
    changelog = "https://github.com/albertodonato/snap-helpers/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}

