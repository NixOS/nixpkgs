{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, pillow
, webcolors
, flit-core
, pytestCheckHook
, pandas
}:

buildPythonPackage rec {
  pname = "tikzplotlib";
  version = "0.10.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PLExHhEnxkEiXsE0rqvpNWwVZ+YoaDa2BTx8LktdHl0=";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    pillow
    webcolors
    flit-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
  ];

  meta = with lib; {
    description = "Save matplotlib figures as TikZ/PGFplots for smooth integration into LaTeX";
    homepage = "https://github.com/nschloe/tikzplotlib";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
