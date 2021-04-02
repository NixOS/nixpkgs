{ lib
, python3
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "qmk";
  version = "0.0.45";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "43f297f36b21d68c34c5efa0ce1449dddb2e28753f80939cadf761ee7a2a0901";
  };

  patches = [
    # https://github.com/qmk/qmk_cli/pull/48
    (fetchpatch {
      name = "remove-unused-install-requires.patch";
      url = "https://github.com/qmk/qmk_cli/commit/75b6ada1feccfa5a9bc2bb07a4cc749ef40d02dd.patch";
      sha256 = "0lwi1dz35p07vha5gwq2jxm5q49vm99ix4jyhd6g6ypqbq1qiwc8";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    milc
  ];

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    description = "A program to help users work with QMK Firmware";
    homepage = "https://github.com/qmk/qmk_cli";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
