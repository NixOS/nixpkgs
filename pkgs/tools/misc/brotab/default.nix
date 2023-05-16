<<<<<<< HEAD
{ lib, fetchFromGitHub, fetchpatch, python }:

python.pkgs.buildPythonApplication rec {
  pname = "brotab";
  version = "1.4.2";
  format = "setuptools";
=======
{ lib, fetchFromGitHub, python }:

python.pkgs.buildPythonApplication rec {
  version = "1.4.2";
  pname = "brotab";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "balta2ar";
    repo = pname;
    rev = version;
    hash = "sha256-HKKjiW++FwjdorqquSCIdi1InE6KbMbFKZFYHBxzg8Q=";
  };

<<<<<<< HEAD
  patches = [
    # https://github.com/balta2ar/brotab/pull/102
    (fetchpatch {
      name = "remove-unnecessary-pip-import.patch";
      url = "https://github.com/balta2ar/brotab/commit/825cd48f255c911aabbfb495f6b8fc73f27d3fe5.patch";
      hash = "sha256-IN28AOLPKPUc3KkxIGFMpZNNXA1+O12NxS+Hl4KMXbg=";
    })
  ];

  propagatedBuildInputs = with python.pkgs; [
    flask
    psutil
    requests
=======
  propagatedBuildInputs = with python.pkgs; [
    requests
    flask
    psutil
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    setuptools
  ];

  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace "Flask==2.0.2" "Flask>=2.0.2" \
      --replace "psutil==5.8.0" "psutil>=5.8.0" \
      --replace "requests==2.24.0" "requests>=2.24.0"
  '';

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/balta2ar/brotab";
    description = "Control your browser's tabs from the command line";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
