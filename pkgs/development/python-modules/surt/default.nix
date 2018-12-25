{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, tldextract
, pytest
}:

buildPythonPackage rec {
  pname = "surt";
  version = "0.3.0";

  # Fetch from GitHub because the PyPI tarball does not include tests/
  src = fetchFromGitHub {
    owner = "internetarchive";
    repo = "surt";
    rev = version;
    sha256 = "10l8zz9ps31rqhawdbzrcnfq9rkzmaaqrkq6i5c35386h0i22c3g";
  };

  propagatedBuildInputs = [ six tldextract ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Sort-friendly URI Reordering Transform (SURT)";
    homepage = https://github.com/internetarchive/surt;
    license = licenses.agpl3;
    maintainers = with maintainers; [ ivan ];
  };
}
