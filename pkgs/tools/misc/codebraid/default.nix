{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "codebraid";
  version = "0.5.0-unstable-2020-08-14";

  src = fetchFromGitHub {
    owner = "gpoore";
    repo = pname;
    rev = "526a223c4fc32c37d6c5c9133524dfa0e1811ca4";
    sha256 = "0qkqaj49k584qzgx9jlsf5vlv4lq7x403s1kig8v87i0kgh55p56";
  };

  propagatedBuildInputs = with python3Packages; [ bespon ];
  # unfortunately upstream doesn't contain tests
  checkPhase = ''
    $out/bin/codebraid --help > /dev/null
  '';
  meta = with lib; {
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
