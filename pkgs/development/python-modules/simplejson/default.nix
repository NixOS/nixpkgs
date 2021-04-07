{ lib
, buildPythonPackage
, fetchFromGitHub
, stdenv
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "simplejson";
  version = "3.17.2";
  doCheck = !stdenv.isDarwin;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2ZC7aKyUUcth43Ce0j6JdjrJ4gb4QfJDlY2M5TLMQ+o=";
  };

  checkInputs = [ pytestCheckHook ];

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
