{ stdenv, buildPythonApplication, fetchFromGitHub, makeWrapper, cmake
, pytestrunner, pytest, six, pyparsing, asn1ate }:

buildPythonApplication rec {
  pname = "asn2quickder";
  version = "1.2-6";

  src = fetchFromGitHub {
    sha256 = "00wifjydgmqw2i5vmr049visc3shjqccgzqynkmmhkjhs86ghzr6";
    rev = "version-${version}";
    owner = "vanrein";
    repo = "quick-der";
  };

  postPatch = ''
    patchShebangs ./python/scripts/*
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [ makeWrapper cmake ];
  checkInputs = [ pytestrunner pytest ];

  propagatedBuildInputs = [ pyparsing asn1ate six ];

  meta = with stdenv.lib; {
    description = "An ASN.1 compiler with a backend for Quick DER";
    homepage = https://github.com/vanrein/asn2quickder;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
