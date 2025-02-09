{ lib
, buildPythonPackage
, fetchFromGitHub
, gflanguages
, num2words
, poetry-core
, protobuf
, pytestCheckHook
, strictyaml
, termcolor
, ufo2ft
, vharfbuzz
, youseedee
}:

buildPythonPackage rec {
  pname = "shaperglot";
  version = "0.3.1";

  # PyPI source tarballs omit tests, fetch from Github instead
  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    rev = "v${version}";
    hash = "sha256-29MzD42rgh+7n/0kjqKGDxXPnUEvj/xxEIKWZg03pxw=";
  };

  pyproject = true;

  propagatedBuildInputs = [
    gflanguages
    num2words
    protobuf
    strictyaml
    termcolor
    ufo2ft
    vharfbuzz
    youseedee
  ];
  nativeBuildInputs = [
    poetry-core
  ];

  doCheck = true;
  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Tool to test OpenType fonts for language support";
    homepage = "https://github.com/googlefonts/shaperglot";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
