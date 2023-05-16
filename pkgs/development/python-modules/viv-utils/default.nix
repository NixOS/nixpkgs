{ lib
, buildPythonPackage
, fetchFromGitHub
, funcy
, intervaltree
, pefile
, typing-extensions
, vivisect
, pytest-sugar
, pytestCheckHook
, python-flirt
}:
buildPythonPackage rec {
  pname = "viv-utils";
<<<<<<< HEAD
  version = "0.7.9";
=======
  version = "0.7.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "viv-utils";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-xM3jtA6fNk36+enL/EcQH59CNajYnGlEDu06QXIFz6A=";
=======
    hash = "sha256-ih6CtnsGfHRLDjoaF7BkoUENu+0pU3NB6TG0A70f3nE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="
  '';

  propagatedBuildInputs = [
    funcy
    intervaltree
    pefile
    typing-extensions
    vivisect
  ];

  nativeCheckInputs = [
    pytest-sugar
    pytestCheckHook
  ];

  passthru = {
    optional-dependencies = {
      flirt = [
        python-flirt
      ];
    };
  };

  meta = with lib; {
    description = "Utilities for working with vivisect";
    homepage = "https://github.com/williballenthin/viv-utils";
    changelog = "https://github.com/williballenthin/viv-utils/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
