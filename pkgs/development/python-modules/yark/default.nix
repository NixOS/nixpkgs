{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonRelaxDepsHook
, click
, colorama
, flask
, requests
, yt-dlp
, progress
}:

buildPythonPackage rec {
  pname = "yark";
  version = "1.2.4";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fdd50d0e832b4522cbe24433f42ed571a1f199f571c1d0c98472b94a501db9cf";
  };

  pythonRelaxDeps = [
    "requests"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    click
    colorama
    flask
    progress
    requests
    yt-dlp
  ];

  # There aren't any unit tests. If test discovery runs, it will crash, halting the build.
  # When upstream adds unit tests, please configure them here. Thanks! ~ C.
  doCheck = false;

  pythonImportsCheck = [
    "yark"
  ];

  meta = with lib; {
    description = "YouTube archiving made simple";
    homepage = "https://github.com/Owez/yark";
    license = licenses.mit;
    maintainers = [ ];
  };
}
