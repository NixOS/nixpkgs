{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "codebraid";
  version = "0.5.0-unstable-2019-12-11";

  src = fetchFromGitHub {
    owner = "gpoore";
    repo = pname;
    rev = "fac1b29";
    sha256 = "0ldfrkkip7i1fdyz1iydyik3mhm0xv0jvxnl37r7g707dl38vf3h";
  };

  propagatedBuildInputs = with python3Packages; [ bespon ];
  # unfortunately upstream doesn't contain tests
  checkPhase = ''
    $out/bin/codebraid --help > /dev/null
  '';
  meta = with stdenv.lib; {
    homepage = "https://github.com/gpoore/codebraid";
    description = ''
      Live code in Pandoc Markdown.

      Codebraid is a Python program that enables executable code in Pandoc
      Markdown documents. Using Codebraid can be as simple as adding a class to
      your code blocks' attributes, and then running codebraid rather than
      pandoc to convert your document from Markdown to another format.
      codebraid supports almost all of pandoc's options and passes them to
      pandoc internally.

      Codebraid provides two options for executing code. It includes a built-in
      code execution system that currently supports Python 3.5+, Julia, Rust,
      R, Bash, and JavaScript. Code can also be executed using Jupyter kernels,
      with support for rich output like plots.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
