{ lib
, unstableGitUpdater
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
, setuptools
, requests
, protobuf
, pycryptodome
, zstandard
, json5
, platformdirs
, cacert
}:

buildPythonApplication rec {
  pname = "nile";
  version = "1.0.3-unstable-2024-06-08";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "nile";
    rev = "fcf57a69d6f322e389a8c21b77215a488fa81132";
    hash = "sha256-zRuWJ0ziKxxOpGyR2IB8LncIFveIyz5PWYXhEHhQEM8=";
  };

  disabled = pythonOlder "3.8";

  propagatedBuildInputs = [
    setuptools
    requests
    protobuf
    pycryptodome
    zstandard
    json5
    platformdirs
  ];

  pyprojectAppendix = ''
    [tool.setuptools.packages.find]
    include = ["nile*"]
  '';

  postPatch = ''
    echo "$pyprojectAppendix" >> pyproject.toml
  '';

  pythonImportsCheck = [ "nile" ];

  meta = with lib; {
    description = "Unofficial Amazon Games client";
    mainProgram = "nile";
    homepage = "https://github.com/imLinguin/nile";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ aidalgol ];
  };

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };
}
