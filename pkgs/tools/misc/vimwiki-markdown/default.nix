{
  lib,
  buildPythonApplication,
  fetchPypi,
  markdown,
  pygments,
}:

buildPythonApplication rec {
  version = "0.4.1";
  format = "setuptools";
  pname = "vimwiki-markdown";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-hJl0OTE6kHucVGOxgOZBG0noYRfxma3yZSrUWEssLN4=";
  };

  propagatedBuildInputs = [
    markdown
    pygments
  ];

  meta = {
    description = "Vimwiki markdown plugin";
    homepage = "https://github.com/WnP/vimwiki_markdown";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seqizz ];
    mainProgram = "vimwiki_markdown";
  };
}
