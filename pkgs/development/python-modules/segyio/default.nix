{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, python
, scikit-build
, pytest
, numpy
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "segyio";
  version = "1.9.9";

  patches = [
    # PR https://github.com/equinor/segyio/pull/531
    (fetchpatch {
        url = "https://github.com/equinor/segyio/commit/628bc5e02d0f98b89fe70b072df9b8e677622e9e.patch";
        sha256 = "sha256-j+vqHZNfPIh+yWBgqbGD3W04FBvFiDJKnmcC/oTk3a8=";
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
    repo = pname;
    rev = version;
    sha256 = "sha256-L3u5BHS5tARS2aIiQbumADkuzw1Aw4Yuav8H8tRNYNg=";
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
