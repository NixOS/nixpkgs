{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, textual
}:

buildPythonPackage rec {
  pname = "textual-slider";
  version = "0.1.2";

  disabled = pythonOlder "3.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u2ODMEVZT4SYgHDKJfTh0vOJC04S3OZCWvK0WvJVWDg=";
  };

  nativeBuildInputs = [
  ];

  propagatedBuildInputs = [
    textual
  ];

  pythonImportsCheck = [ "textual_slider" ];

  meta = with lib; {
    description = "A Textual widget for a simple slider.";
    homepage = "https://github.com/TomJGooding/textual-slider";
    changelog = "https://github.com/TomJGooding/textual-slider/blob/main/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jloyet ];
  };
}
