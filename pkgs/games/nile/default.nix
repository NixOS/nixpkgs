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
  version = "unstable-2024-03-09";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "nile";
    rev = "ae09acfc20fe4e462762666871f78caae70f6c74";
    hash = "sha256-hqhIacsbultY3CvvkYAZHmhCkQLi1mkPQwkztaUOd10=";
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

  passthru.updateScript = unstableGitUpdater { };
}
