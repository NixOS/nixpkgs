{ lib
, buildPythonApplication
, fetchPypi
, markdown
, pygments
}:

buildPythonApplication rec {
  version = "0.3.3";
  pname = "vimwiki-markdown";

  src = fetchPypi {
    inherit version pname;
    sha256 = "ee4ef08f7e4df27f67ffebb5fa413a7cf4fad967a248c1c75d48b00122a5b945";
  };

  propagatedBuildInputs= [
    markdown
    pygments
  ];

  meta = with lib; {
    description = "Vimwiki markdown plugin";
    homepage = "https://github.com/WnP/vimwiki_markdown";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
