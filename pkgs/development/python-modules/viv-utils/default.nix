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
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "viv-utils";
    rev = "v${version}";
    sha256 = "sha256-JDu+1n1wP2Vsp2V/bKdE+RFp6bE8RNmimi4wdsatwME=";
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

  checkInputs = [
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
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
