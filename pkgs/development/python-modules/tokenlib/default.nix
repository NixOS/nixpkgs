{ stdenv
, buildPythonPackage
, fetchgit
, requests
, webob
}:

buildPythonPackage rec {
  pname = "tokenlib";
  version = "0.3.1";

  src = fetchgit {
    url = https://github.com/mozilla-services/tokenlib.git;
    rev = "refs/tags/${version}";
    sha256 = "0bq6dqyfwh29pg8ngmrm4mx4q27an9lsj0p9l79p9snn4g2rxzc8";
  };

  propagatedBuildInputs = [ requests webob ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mozilla-services/tokenlib;
    description = "Generic support library for signed-token-based auth schemes";
    license = licenses.mpl20;
  };

}
