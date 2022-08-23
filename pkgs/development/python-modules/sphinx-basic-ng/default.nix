{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-basic-ng";
  version = "0.0.1.a12";
  disable = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "sphinx-basic-ng";
    rev = version;
    sha256 = "sha256-3/a/xHPNO96GEMLgWGTLdFoojVsjNyxYgY1gAZr75S0=";
  };

  patches = [
    (fetchpatch {
      name = "fix-import-error.patch";
      url = "https://github.com/pradyunsg/sphinx-basic-ng/pull/32/commits/323a0085721b908aa11bc3c36c51e16f517ee023.patch";
      sha256 = "sha256-/G1wLG/08u2s3YENSKSYekLrV1fUkxDAlxc3crTQNHk=";
    })
  ];

  propagatedBuildInputs = [
    sphinx
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "sphinx_basic_ng" ];

  meta = with lib; {
    description = "A modernised skeleton for Sphinx themes";
    homepage = "https://sphinx-basic-ng.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
