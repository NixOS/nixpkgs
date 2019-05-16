{ fetchFromGitHub, pythonPackages, stdenv }:

with pythonPackages;
buildPythonApplication rec {
  pname = "MarkdownPP";
  version = "1.4";
  propagatedBuildInputs = [ pillow watchdog ];
  checkPhase = ''
    cd test
    PATH=$out/bin:$PATH ${python}/bin/${python.executable} test.py
  '';
  src = fetchFromGitHub {
    owner = "jreese";
    repo = "markdown-pp";
    rev = "v${version}";
    sha256 = "1xmc0cxvvf6jzr7p4f0hm8icysrd44sy2kgff9b99lr1agwkmysq";
  };
  meta = with stdenv.lib; {
    description = "Preprocessor for Markdown files to generate a table of contents and other documentation needs";
    license = licenses.mit;
    homepage = "https://github.com/jreese/markdown-pp";
    maintainers = with maintainers; [ zgrannan ];
  };
}
