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
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "viv-utils";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ih6CtnsGfHRLDjoaF7BkoUENu+0pU3NB6TG0A70f3nE=";
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
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
