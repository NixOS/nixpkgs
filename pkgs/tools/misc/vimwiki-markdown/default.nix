{ lib
, buildPythonApplication
, fetchPypi
, markdown
, pygments
}:

buildPythonApplication rec {
  version = "0.4.0";
  pname = "vimwiki-markdown";

  src = fetchPypi {
    inherit version pname;
    sha256 = "e898c58fa6ecbb7474738d79c44db2b6ab3adfa958bffe80089194c2a70b1ec0";
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
    mainProgram = "vimwiki_markdown";
  };
}
