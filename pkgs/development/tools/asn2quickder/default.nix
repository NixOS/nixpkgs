{ lib
, buildPythonApplication
, fetchFromGitLab
, makeWrapper
, cmake
, six
, pyparsing
, asn1ate
, colored
}:

buildPythonApplication rec {
  pname = "asn2quickder";
  version = "1.7.1";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "quick-der";
    rev = "v${version}";
    sha256 = "sha256-f+ph5PL+uWRkswpOLDwZFWjh938wxoJ6xocJZ2WZLEk=";
  };

  postPatch = ''
    patchShebangs ./python/scripts/*

    # Unpin pyparsing 3.0.0. Issue resolved in latest version.
    substituteInPlace setup.py --replace 'pyparsing==3.0.0' 'pyparsing'
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [ makeWrapper cmake ];

  propagatedBuildInputs = [ pyparsing asn1ate six colored ];

  doCheck = false; # Flaky tests

  meta = with lib; {
    description = "ASN.1 compiler with a backend for Quick DER";
    homepage = "https://gitlab.com/arpa2/quick-der";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
