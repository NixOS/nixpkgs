{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, matchpy
, numpy
, astunparse
, typing-extensions
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "uarray";
  version = "0.8.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = pname;
    rev = version;
    sha256 = "1x2jp7w2wmn2awyv05xs0frpq0fa0rprwcxyg72wgiss0bnzxnhm";
  };

  patches = [(
    # Fixes a compile error with newer versions of GCC -- should be included
    # in the next release after 0.8.2
    fetchpatch {
      url = "https://github.com/Quansight-Labs/uarray/commit/a2012fc7bb94b3773eb402c6fe1ba1a894ea3d18.patch";
      sha256 = "1qqh407qg5dz6x766mya2bxrk0ffw5h17k478f5kcs53g4dyfc3s";
    }
  )];

  nativeCheckInputs = [ pytestCheckHook pytest-cov ];
  propagatedBuildInputs = [ matchpy numpy astunparse typing-extensions ];

  # Tests must be run from outside the source directory
  preCheck = ''
    cd $TMP
  '';
  pytestFlagsArray = ["--pyargs" "uarray"];
  pythonImportsCheck = [ "uarray" ];

  meta = with lib; {
    description = "Universal array library";
    homepage = "https://github.com/Quansight-Labs/uarray";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
