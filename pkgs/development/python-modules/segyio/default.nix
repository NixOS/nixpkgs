{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
    # Bump minimum CMake version to 3.11
    (fetchpatch {
      url = "https://github.com/equinor/segyio/commit/3e2cbe6ca6d4bc7d4f4d95666f5d2983836e8461.patch?full_index=1";
      hash = "sha256-sOBHi8meMSkxEZy0AXwebAnIVPatpwQHd+4Co5zIhLQ=";
    })
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
