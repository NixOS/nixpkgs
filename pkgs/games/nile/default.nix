{ lib
, gitUpdater
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
}:

let
  version = "1.1.2";
in
buildPythonApplication {
  pname = "nile";
  inherit version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "nile";
    rev = "v${version}";
    hash = "sha256-/C4b8wPKWHGgiheuAN7AvU+KcD5aj5i6KzgFSdTIkNI=";
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

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };
}
