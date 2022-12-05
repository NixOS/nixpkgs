{ lib
, fetchFromGitLab
, buildPythonPackage
, cookiecutter
, requests
, pyyaml
, jsonschema
, argcomplete
, watchdog
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clickable";
  version = "7.7.2";

  src = fetchFromGitLab {
    owner = "clickable";
    repo = "clickable";
    rev = "v${version}";
    sha256 = "1l67n07mb18ffryfwk21q6lfsmvij6gigyi4kp2kn5dqh1hi17bl";
  };

  propagatedBuildInputs = [
    cookiecutter
    requests
    pyyaml
    jsonschema
    argcomplete
    watchdog
  ];
  
  # Disable checks due to them requiring docker or networking
  doCheck = false;

  meta = {
    description = "A build system for Ubuntu Touch apps";
    homepage = "https://clickable-ut.dev";
    changelog = "https://clickable-ut.dev/en/latest/changelog.html";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ilyakooo0 ];
  };
}
