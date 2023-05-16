{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, deprecated
, humanize
, matplotlib
, nibabel
, numpy
, parameterized
, scipy
, simpleitk
, torch
, tqdm
, typer
}:

buildPythonPackage rec {
  pname = "torchio";
<<<<<<< HEAD
  version = "0.19.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.18.90";
  format = "pyproject";
  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fepegar";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-SNX558kSRCS9Eks00Kj2kFmo7hCUgV6saYLsnx/Kus0=";
=======
    hash = "sha256-h8cvNhOkjMMbQ6Nry8FKtwnK+yhRYRGjXi/xp0i5yyY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    deprecated
    humanize
    nibabel
    numpy
    scipy
    simpleitk
    torch
    tqdm
    typer
  ] ++ typer.passthru.optional-dependencies.all;

  nativeCheckInputs = [ pytestCheckHook matplotlib parameterized ];
  disabledTests = [
    # tries to download models:
    "test_load_all"
  ] ++ lib.optionals stdenv.isAarch64 [
    # RuntimeError: DataLoader worker (pid(s) <...>) exited unexpectedly
    "test_queue_multiprocessing"
  ];
  pythonImportsCheck = [
    "torchio"
    "torchio.data"
  ];

  meta = with lib; {
    description = "Medical imaging toolkit for deep learning";
<<<<<<< HEAD
    homepage = "https://torchio.readthedocs.io";
=======
    homepage = "http://www.torchio.org/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
  };
}
