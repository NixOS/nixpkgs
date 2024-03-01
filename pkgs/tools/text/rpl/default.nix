{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "rpl";
  version = "1.15.5";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rhPS+hwbjqq3X/V1bL6pzGg2tVxBkeMyUhaCvmneG4M=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
  ];

  nativeCheckInputs = [
    python3Packages.pytest-datafiles
    python3Packages.pytestCheckHook
  ];

  propagatedBuildInputs = [
    python3Packages.argparse-manpage
    python3Packages.chainstream
    python3Packages.chardet
    python3Packages.regex
  ];

  meta = with lib; {
    description = "Replace strings in files";
    homepage = "https://github.com/rrthomas/rpl";
    license = licenses.gpl2;
    maintainers = with maintainers; [ cbley ];
  };
}
