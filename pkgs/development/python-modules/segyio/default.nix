{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  ninja,
  scikit-build,
  pytest,
  numpy,
}:

buildPythonPackage rec {
  pname = "segyio";
  version = "1.9.13";
  pyproject = false; # Built with cmake

  patches = [
    # https://github.com/equinor/segyio/pull/570
    ./add_missing_cstdint.patch
    # https://github.com/equinor/segyio/pull/576/
    ./fix-setuptools.patch
    ./explicitly-cast.patch
    ./numpy-2.patch
  ];

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
    repo = "segyio";
    tag = "v${version}";
    hash = "sha256-uVQ5cs9EPGUTSbaclLjFDwnbJevtv6ie94FLi+9vd94=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build
  ];

  # I'm not modifying the checkPhase nor adding a pytestCheckHook because the pytest is called
  # within the cmake test phase
  nativeCheckInputs = [
    pytest
    numpy
  ];

  meta = {
    description = "Fast Python library for SEGY files";
    homepage = "https://github.com/equinor/segyio";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ atila ];
  };
}
