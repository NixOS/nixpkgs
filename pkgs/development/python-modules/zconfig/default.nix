{ stdenv
, fetchPypi
, fetchpatch
, buildPythonPackage
, zope_testrunner
, manuel
, docutils
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "ZConfig";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s7aycxna07a04b4rswbkj4y5qh3gxy2mcsqb9dmy0iimj9f9550";
  };

  patches = [
    # fixes 3.8+ logger validation issues, has been merged into master, remove next bump
    (fetchpatch {
      url = "https://github.com/zopefoundation/ZConfig/commit/f0c2990d35ac3c924ecc8be4a5c71c8e4abbd0e5.patch";
      sha256 = "1bjg3wrvii0rwzf3s0vlpzgg2ckj0h2zxkyxwjcr64s4k2vaq9ij";
    })
  ] ++ stdenv.lib.optional stdenv.hostPlatform.isMusl ./remove-setlocale-test.patch;

  buildInputs = [ manuel docutils ];
  propagatedBuildInputs = [ zope_testrunner ];

  meta = with stdenv.lib; {
    description = "Structured Configuration Library";
    homepage = "https://pypi.python.org/pypi/ZConfig";
    license = licenses.zpl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
