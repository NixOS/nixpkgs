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
  version = "2023.7.23";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lI+Ws1uVC8cnRERmfY7j5vPjQGEAH6zef7nBnd/hC+I=";
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
