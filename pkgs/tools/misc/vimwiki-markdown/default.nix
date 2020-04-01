{ stdenv
, buildPythonApplication
, fetchPypi
, markdown
, pygments
}:

buildPythonApplication rec {
  version = "0.3.0";
  pname = "vimwiki-markdown";

  src = fetchPypi {
    inherit version pname;
    sha256 = "1icfnc623f9pyn59wgb76g0fnsx41s87q69x354qy17gw23bxabx";
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
