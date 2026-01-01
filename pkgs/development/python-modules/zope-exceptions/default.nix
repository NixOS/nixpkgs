{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "zope-exceptions";
<<<<<<< HEAD
  version = "6.0";
  pyproject = true;

=======
  version = "5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.exceptions";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-LLKS/O1sfrHRfEgbb3GO+/hBtIC9CvfNjorqiKTgujo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

=======
    hash = "sha256-jbzUUB6ifTfxiGEiyAmsDoDLyRVuZPgIsN8mCNJkv4Q=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [
    setuptools
  ];

  dependencies = [
<<<<<<< HEAD
=======
    setuptools
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    zope-interface
  ];

  # circular deps
  doCheck = false;

  pythonImportsCheck = [ "zope.exceptions" ];

  meta = {
    description = "Exception interfaces and implementations";
    homepage = "https://pypi.python.org/pypi/zope.exceptions";
    changelog = "https://github.com/zopefoundation/zope.exceptions/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
