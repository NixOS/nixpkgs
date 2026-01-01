{
  lib,
  appdirs,
  buildPythonPackage,
  fetchFromGitHub,
  graphviz,
  ifaddr,
  lxml,
  mock,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "soco";
<<<<<<< HEAD
  version = "0.30.13";
=======
  version = "0.30.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AmkYEsvVEEzCJYZf0c9OQqb4EzoZT47Pn94n4dlVW1w=";
=======
    hash = "sha256-PczdR6lG4oKsg5eRIPSjRgYMERyvDeLnXpeOj/1aY24=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    ifaddr
    lxml
    requests
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    graphviz
    mock
    requests-mock
  ];

  pythonImportsCheck = [ "soco" ];

<<<<<<< HEAD
  meta = {
    description = "CLI and library to control Sonos speakers";
    homepage = "http://python-soco.com/";
    changelog = "https://github.com/SoCo/SoCo/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
=======
  meta = with lib; {
    description = "CLI and library to control Sonos speakers";
    homepage = "http://python-soco.com/";
    changelog = "https://github.com/SoCo/SoCo/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
