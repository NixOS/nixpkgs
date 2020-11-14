{ stdenv
, buildPythonApplication
, fetchPypi
, markdown
, pygments
}:

buildPythonApplication rec {
  version = "0.3.2";
  pname = "vimwiki-markdown";

  src = fetchPypi {
    inherit version pname;
    sha256 = "e8dc7de7fc7f88480acb940aa51088464b9911c85cc3d5cca962a45e75ff9b81";
  };

  propagatedBuildInputs= [
    markdown
    pygments
  ];

  meta = with stdenv.lib; {
    description = "Vimwiki markdown plugin";
    homepage = "https://github.com/WnP/vimwiki_markdown";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
