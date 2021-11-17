{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "simplejson";
  version = "3.17.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r7PACv9itFL8qN+ov8HklcqcMui54hOOY66tqXS5NMc=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [
    "simplejson"
  ];

  meta = with lib; {
    description = "Extensible JSON encoder/decoder for Python";
    longDescription = ''
      simplejson covers the full JSON specification for both encoding
      and decoding, with unicode support. By default, encoding is done
      in an encoding neutral fashion (plain ASCII with \uXXXX escapes
      for unicode characters).
    '';
    homepage = "https://github.com/simplejson/simplejson";
    license = with licenses; [ mit afl21 ];
    maintainers = with maintainers; [ fab ];
  };
}
