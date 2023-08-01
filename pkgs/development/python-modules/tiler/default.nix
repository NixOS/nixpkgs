{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, setuptools-scm-git-archive
, wheel
, numpy
, tqdm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tiler";
  version = "0.5.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2HWO/iJ9RCWNVmw2slu9F/+Mchk3evB5/F8EfbuMI/Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'setuptools_scm[toml] >= 4, <6' 'setuptools_scm[toml] >= 4'
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    setuptools-scm-git-archive
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tiler" ];

  meta = with lib; {
    description = "N-dimensional NumPy array tiling and merging with overlapping, padding and tapering";
    homepage = "https://the-lay.github.io/tiler/";
    license = licenses.mit;
    maintainers = with maintainers; [ atila ];
  };
}
