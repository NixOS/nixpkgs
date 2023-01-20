{ lib, buildPythonPackage, fetchPypi,
  click, colorama, flask, requests, yt-dlp }:

buildPythonPackage rec {
  pname = "yark";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KMnQpEH2Z19Y0jBjqx2rZjmlle2M9bcuDCjDIljQEYY=";
  };

  propagatedBuildInputs = [
    click colorama flask requests yt-dlp
  ];

  # There aren't any unit tests. If test discovery runs, it will crash, halting the build.
  # When upstream adds unit tests, please configure them here. Thanks! ~ C.
  doCheck = false;

  meta = with lib; {
    description = "YouTube archiving made simple";
    homepage = "https://github.com/Owez/yark";
    license = licenses.mit;
  };
}
