{ fetchFromGitHub, pythonPackages, stdenv }:

with pythonPackages;
buildPythonApplication rec {
  pname = "MarkdownPP";
  version = "1.3";
  doCheck = false;
  propagatedBuildInputs = [ watchdog ];
  src = fetchFromGitHub {
    owner = "jreese";
    repo = "markdown-pp";
    rev = "8c1e3fb659ece44a2992b0e341dd5a0f2322a871";
    sha256 = "1f9pbmjwnn04z6fl872rryzcssqsxcq5yzkpaqcmxgjj11hxbjlx";
  };
  meta = with stdenv.lib; {
    description = "Preprocessor for Markdown files to generate a table of contents and other documentation needs";
    license = licenses.mit;
    homepage = "https://github.com/jreese/markdown-pp";
    maintainers = with maintainers; [ zgrannan ];
  };
}
