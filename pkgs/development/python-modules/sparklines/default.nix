{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  termcolor,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sparklines";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deeplook";
    repo = "sparklines";
    tag = "v${version}";
    sha256 = "sha256-jiMrxZMWN+moap0bDH+uy66gF4XdGst9HJpnboJrQm4=";
  };

  propagatedBuildInputs = [
    hatchling
    termcolor
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sparklines" ];

  postPatch = ''
    export TMPDIR=$PWD/tmp
    mkdir -p $TMPDIR
    substituteInPlace tests/test_sparkline.py \
      --replace-fail "/tmp/" "$TMPDIR/"
  '';

  meta = with lib; {
    description = "This Python package implements Edward Tufte's concept of sparklines, but limited to text only";
    mainProgram = "sparklines";
    homepage = "https://github.com/deeplook/sparklines";
    maintainers = with maintainers; [
      rhoriguchi
    ];
    license = licenses.mit;
  };
}
