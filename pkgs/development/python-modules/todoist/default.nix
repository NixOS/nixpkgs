{ stdenv, fetchPypi, buildPythonPackage
, requests, fetchpatch, pythonOlder, typing
}:

buildPythonPackage rec {
  pname = "todoist-python";
  version = "8.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "750b2d2300e8590cd56414ab7bbbc8dfcaf8c27102b342398955812176499498";
  };

  patches = [
    # From https://github.com/Doist/todoist-python/pull/80
    (fetchpatch {
      url = "https://github.com/Doist/todoist-python/commit/605443c67a8e2f105071e0da001c9f6f2a89ef19.patch";
      sha256 = "0ah0s5by783kqlaimsbxz11idz0bhc2428aw9vdjpngmzb7ih1pa";
    })
    (fetchpatch {
      url = "https://github.com/Doist/todoist-python/commit/f2f8e1e5b3ab1674ad9f0dff885702a25d1d18e9.patch";
      sha256 = "1kp63yk9kj87zvvgfl60m6lxdm5sx3dny4g0s67ap1jbz350wifn";
    })
  ];

  propagatedBuildInputs = [ requests ] ++ stdenv.lib.optional (pythonOlder "3.5") typing;

  meta = {
    description = "The official Todoist Python API library";
    homepage = "https://todoist-python.readthedocs.io/en/latest/";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ma27 ];
  };
}
