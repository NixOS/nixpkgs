{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, canonicaljson
, unpaddedbase64
, pynacl
, typing-extensions
, setuptools-scm
, importlib-metadata
, pythonOlder
}:

buildPythonPackage rec {
  pname = "signedjson";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0280f8zyycsmd7iy65bs438flm7m8ffs1kcxfbvhi8hbazkqc19m";
  };

  patches = [
    # Do not require importlib_metadata on python 3.8
    (fetchpatch {
      url = "https://github.com/matrix-org/python-signedjson/commit/c40c83f844fee3c1c7b0c5d1508f87052334b4e5.patch";
      sha256 = "109f135zn9azg5h1ljw3v94kpvnzmlqz1aiknpl5hsqfa3imjca1";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ canonicaljson unpaddedbase64 pynacl typing-extensions ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  meta = with lib; {
    homepage = "https://pypi.org/project/signedjson/";
    description = "Sign JSON with Ed25519 signatures";
    license = licenses.asl20;
  };
}
