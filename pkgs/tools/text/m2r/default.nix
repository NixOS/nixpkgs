{ lib
, buildPythonApplication
, fetchFromGitHub
, docutils
, mistune
, pygments
}:

buildPythonApplication rec {
  pname = "m2r";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "miyakogi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JNLPEXMoiISh4RnKP+Afj9/PJp9Lrx9UYHsfuGAL7uI=";
  };

  buildInputs = [
    docutils
    mistune
    pygments
  ];

  meta = with lib; {
    homepage = "https://github.com/miyakogi/m2r";
    description = "Markdown-to-RestructuredText converter";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
