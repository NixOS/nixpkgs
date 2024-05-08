{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "rpl";
  version = "1.15.6";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4vUnFfxiPvyg9gtwiQE3nHZBnqBtBVwhM3KQzkjzw/I=";
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
    mainProgram = "rpl";
    homepage = "https://github.com/rrthomas/rpl";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ cbley ];
  };
}
