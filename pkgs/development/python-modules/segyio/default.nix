{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, python
, scikit-build
, pytest
, numpy
}:

stdenv.mkDerivation rec {
  pname = "segyio";
  version = "1.9.12";

  postPatch = ''
    # Removing unecessary build dependency
    substituteInPlace python/setup.py --replace "'pytest-runner'," ""

    # Fixing bug making one test fail in the python 3.10 build
    substituteInPlace python/segyio/open.py --replace \
    "cube_metrics = f.xfd.cube_metrics(iline, xline)" \
    "cube_metrics = f.xfd.cube_metrics(int(iline), int(xline))"
  '';

  src = fetchFromGitHub {
    owner = "equinor";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+N2JvHBxpdbysn4noY/9LZ4npoQ9143iFEzaxoafnms=";
  };

  nativeBuildInputs = [ cmake ninja python scikit-build ];

  doCheck = true;
  # I'm not modifying the checkPhase nor adding a pytestCheckHook because the pytest is called
  # within the cmake test phase
  nativeCheckInputs = [ pytest numpy ];

  meta = with lib; {
    description = "Fast Python library for SEGY files";
    homepage = "https://github.com/equinor/segyio";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ atila ];
  };
}
