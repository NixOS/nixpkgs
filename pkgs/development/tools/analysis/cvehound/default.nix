{ lib, fetchFromGitHub, coccinelle, gnugrep, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "cvehound";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "evdenis";
    repo = "cvehound";
    rev = version;
    sha256 = "sha256-m8vpea02flQ8elSvGWv9FqBhsEcBzRYjcUk+dc4kb2M=";
  };

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ coccinelle gnugrep ]}"
  ];

  propagatedBuildInputs = [
    psutil
    setuptools
    sympy
  ];

  checkInputs = [
    GitPython
    pytestCheckHook
  ];

  # Tries to clone the kernel sources
  doCheck = false;

  meta = with lib; {
    description = "tool to check linux kernel source dump for known CVEs";
    homepage = "https://github.com/evdenis/cvehound";
    # See https://github.com/evdenis/cvehound/issues/22
    license = with licenses; [ gpl2Only gpl3Only ];
    maintainers = with maintainers; [ ambroisie ];
  };
}
