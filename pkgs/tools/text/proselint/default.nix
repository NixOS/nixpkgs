{
  lib,
  python3Packages,
  fetchurl,
  buildPythonApplication,
  click,
}:
buildPythonApplication rec {
  pname = "proselint";
  version = "0.14.0";

  doCheck = false; # fails to pass because it tries to run in home directory
  format = "pyproject";

  src = fetchurl {
    url = "mirror://pypi/p/proselint/${pname}-${version}.tar.gz";
    sha256 = "YklkJyvqFHZ+XfJWHYfdMHZ5OMjLUvsjWFvDdYBoDoY=";
  };

  nativeBuildInputs = [ python3Packages.poetry-core ];
  propagatedBuildInputs = [ click ];

  meta = with lib; {
    description = "A linter for prose.";
    mainProgram = "proselint";

    homepage = "https://github.com/amperser/proselint";
    changelog = "https://github.com/amperser/proselint/blob/main/CHANGELOG.md#proselint${
      lib.replaceStrings [ "." ] [ "" ] version
    }";

    downloadPage = "https://pypi.org/project/proselint/${version}/#files";

    license = licenses.bsd3;
    maintainers = [ ];
  };
}
