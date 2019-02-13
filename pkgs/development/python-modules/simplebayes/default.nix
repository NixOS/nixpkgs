{ stdenv
, buildPythonPackage
, fetchFromGitHub
, nose
, mock
, isPy3k
}:

buildPythonPackage rec {
  pname = "simplebayes";
  version = "1.5.8";

  # Use GitHub instead of pypi, because it contains tests.
  src = fetchFromGitHub {
    repo = "simplebayes";
    owner = "hickeroar";
    # NOTE: This is actually 1.5.8 but the tag is wrong!
    rev = "1.5.7";
    sha256 = "0mp7rvfdmpfxnka4czw3lv5kkh6gdxh6dm4r6hcln1zzfg9lxp4h";
  };

  checkInputs = [ nose mock ];

  postPatch = stdenv.lib.optionalString isPy3k ''
    sed -i -e 's/open *(\([^)]*\))/open(\1, encoding="utf-8")/' setup.py
  '';

  checkPhase = "nosetests tests/test.py";

  meta = with stdenv.lib; {
    description = "Memory-based naive bayesian text classifier";
    homepage = "https://github.com/hickeroar/simplebayes";
    license = licenses.mit;
  };

}
