{ lib, buildPythonPackage, fetchPypi, pythonOlder, requests }:

buildPythonPackage rec {
  pname = "instaloader";
  version = "4.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9615a12a5a01a8b6c9d99a2a047b21d81b341cfd77656b9261bda30ece0cd562";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [ requests ];

  # No tests implemented
  doCheck = false;
  pythonImportsCheck = [ "instaloader" ];

  meta = with lib; {
    description = "Download pictures (or videos) along with their captions and other metadata from Instagram";
    homepage = "https://instaloader.github.io/";
    changelog = "https://github.com/instaloader/instaloader/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kazenyuk ];
  };
}
