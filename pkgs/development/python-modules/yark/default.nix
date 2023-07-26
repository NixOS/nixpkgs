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
  version = "1.2.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8O4EpHb1fP/O/t6hS1K1ylSXNKBuiipo7wvEnUJODSw=";
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
