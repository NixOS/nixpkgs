{ 
  lib
  , buildPythonPackage
  , fetchFromGitHub
  , cloudpickle
  , ipykernel
  , wurlitzer
  , jupyter_client
  , pyzmq 
  , numpy
  , pandas
  , scipy
  , matplotlib
  , xarray
  , pytest
  , flaky
  , isPy3k
}:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = "spyder-kernels";
    rev = "v0.5.2";
    sha256 = "1yan589g0470y61bcyjy3wj13i94ndyffckqdyrg97vw2qhfrisb";
  };

  # requirement xarray not available on Py2k
  disabled = !isPy3k;

  propagatedBuildInputs = [
    cloudpickle
    ipykernel
    wurlitzer
    jupyter_client
    pyzmq
  ];

  checkInputs = [
    numpy
    pandas
    scipy
    matplotlib
    xarray
    pytest
    flaky
  ];

  # skipped tests:
  # turtle requires graphics
  # cython test fails, I don't think this can ever access cython?
  # umr pathlist test assumes standard directories, not compatible with nix
  checkPhase = ''
    export JUPYTER_RUNTIME_DIR=$(mktemp -d)
    pytest -x -vv -k '\
      not test_turtle_launch \
      and not test_umr_skip_cython \
      and not test_umr_pathlist' \
      -W 'ignore::DeprecationWarning' \
      spyder_kernels
  '';

  meta = with lib; {
    description = "Jupyter kernels for Spyder's console";
    homepage = "https://github.com/spyder-ide/spyder-kernels";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner marcus7070 ];
  };
}
