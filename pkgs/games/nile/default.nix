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
  version = "1.0.3-unstable-2024-05-25";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "nile";
    rev = "6e6968c37aef59772248de8602374b4831202854";
    hash = "sha256-0UHXF9It/JjHMfBzQM5GRn4FU9rNrh3EM90M8Ki/fTE=";
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
