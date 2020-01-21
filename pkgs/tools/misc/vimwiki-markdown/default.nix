{ stdenv
, buildPythonApplication
, fetchPypi
, markdown
, pygments
}:

buildPythonApplication rec {
  version = "0.2.0";
  pname = "vimwiki-markdown";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0k7srlglhq4bm85kgd5ismslrk1fk8v16mm41a8k0kmcr9k4vi4a";
  };

  propagatedBuildInputs= [
    markdown
    pygments
  ];

  meta = with stdenv.lib; {
    description = "Vimwiki markdown plugin";
    homepage = https://github.com/WnP/vimwiki_markdown;
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
