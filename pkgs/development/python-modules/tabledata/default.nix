{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  dataproperty,
  typepy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tabledata";
  version = "1.3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-kZAEKUOcxb3fK3Oh6+4byJJlB/xzDAEGNpUDEKyVkhs=";
  };

  propagatedBuildInputs = [
    dataproperty
    typepy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/tabledata";
    description = "Library to represent tabular data";
    changelog = "https://github.com/thombashi/tabledata/releases/tag/${src.tag}";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
