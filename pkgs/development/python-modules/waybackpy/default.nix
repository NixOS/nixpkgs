{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  urllib3,
  requests,
  pytest,
}:
buildPythonPackage rec {
  pname = "waybackpy";
  version = "3.0.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SXo3F1arp2ROt62g69TtsVy4xTvBNMyXO/AjoSyv+D8=";
  };

  dependencies = [
    click
    urllib3
    requests
  ];

  nativeBuildInputs = [ pytest ];

  pythonImportsCheck = [ "waybackpy" ];

  meta = with lib; {
    homepage = "https://akamhy.github.io/waybackpy/";
    description = "Wayback Machine API interface & a command-line tool";
    license = licenses.mit;
    maintainers = with maintainers; [ chpatrick ];
  };
}
