{ stdenv, buildPythonApplication, fetchFromGitHub, pypdf2, more-itertools }:

buildPythonApplication rec {
  pname = "stapler";
  version = "2016-04-24";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "hellerbarde";
    repo = pname;
    rev = "7c153e6a8f52573ff886ebf0786b64e17699443a";
    sha256 = "1wyrsfp2zrc23k853if4lp2lp0rzscsg1g4wijks0gha1zap94wy";
  };

  propagatedBuildInputs = [ pypdf2 more-itertools ];

  checkPhase = ''
    staplelib/tests.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/hellerbarde/stapler;
    description = "Manipulate PDF documents from the command line";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
