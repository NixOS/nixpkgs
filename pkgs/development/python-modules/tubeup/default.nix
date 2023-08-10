{ lib
, buildPythonPackage
, internetarchive
, fetchPypi
, yt-dlp
, docopt
, pythonOlder
, urllib3
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "tubeup";
  version = "2023.8.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9jSPFKS1+mGprgGj1c6hOrOo/w2e7A+OXSUjQUm+NCg=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    internetarchive
    docopt
    urllib3
    yt-dlp
  ];

  pythonRelaxDeps = [
    "urllib3"
    "docopt"
  ];

  pythonImportsCheck = [
    "tubeup"
  ];

  # Tests failing upstream
  doCheck = false;

  meta = with lib; {
    description = "Youtube (and other video site) to Internet Archive Uploader";
    homepage = "https://github.com/bibanon/tubeup";
    changelog = "https://github.com/bibanon/tubeup/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ marsam ];
  };
}
