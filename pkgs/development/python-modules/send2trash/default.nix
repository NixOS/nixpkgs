{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Send2Trash";
  version = "1.8.1b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hsoft";
    repo = "send2trash";
    rev = "refs/tags/${version}";
    hash = "sha256-kDUEfyMTk8CXSxTEi7E6kl09ohnWHeaoif+EIaIJh9Q=";
  };

  postPatch = ''
    # Confuses setuptools validation
    # setuptools.extern.packaging.requirements.InvalidRequirement: One of the parsed requirements in `extras_require[win32]` looks like a valid environment marker: 'sys_platform == "win32"'
    sed -i '/win32 =/d' setup.cfg

    # setuptools.extern.packaging.requirements.InvalidRequirement: One of the parsed requirements in `extras_require[objc]` looks like a valid environment marker: 'sys_platform == "darwin"'
    sed -i '/objc =/d' setup.cfg
  '';

  nativeBuildInputs = [
    setuptools
  ];

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Send file to trash natively under macOS, Windows and Linux";
    homepage = "https://github.com/hsoft/send2trash";
    changelog = "https://github.com/arsenetar/send2trash/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
