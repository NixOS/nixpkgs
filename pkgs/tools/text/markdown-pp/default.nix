{ fetchFromGitHub, pythonPackages, stdenv }:

with pythonPackages;
buildPythonApplication rec {
  pname = "MarkdownPP";
  version = "1.5.1";
  propagatedBuildInputs = [ pillow watchdog ];
  checkPhase = ''
    cd test
    PATH=$out/bin:$PATH ${python}/bin/${python.executable} test.py
  '';
  src = fetchFromGitHub {
    owner = "jreese";
    repo = "markdown-pp";
    rev = "v${version}";
    sha256 = "180i5wn9z6vdk2k2bh8345z3g80hj7zf5s2pq0h7k9vaxqpp7avc";
  };
  meta = with stdenv.lib; {
    description = "Preprocessor for Markdown files to generate a table of contents and other documentation needs";
    license = licenses.mit;
    homepage = "https://github.com/jreese/markdown-pp";
    maintainers = with maintainers; [ zgrannan ];
  };
}
