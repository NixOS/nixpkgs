{ lib
, buildPythonPackage
, fetchFromGitHub
, stdenv
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "simplejson";
  version = "3.18.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-X1lD/kCbKDPPgpr2deoVbC5LADqBlNZHvDg7206E9ZE=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [ "simplejson" ];

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
