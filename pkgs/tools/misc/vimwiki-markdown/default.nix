{ stdenv
, buildPythonApplication
, fetchPypi
, markdown
, pygments
}:

buildPythonApplication rec {
  version = "0.3.1";
  pname = "vimwiki-markdown";

  src = fetchPypi {
    inherit version pname;
    sha256 = "50032c62947422c8afbc1733e50526818df7d885d1cc41a27ff65fc26cd3c1c5";
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
