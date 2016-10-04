{ stdenv, fetchFromGitHub, pythonPackages, httpie }:

pythonPackages.buildPythonApplication rec {
  version = "0.2.0";
  name = "http-prompt";

  src = fetchFromGitHub {
    rev = "v${version}";
    repo = "http-prompt";
    owner = "eliangcs";
    sha256 = "0hgw3kx9rfdg394darms3vqcjm6xw6qrm8gnz54nahmyxnhrxnpp";
  };

  propagatedBuildInputs = with pythonPackages; [
    click
    httpie
    parsimonious
    prompt_toolkit
    pygments
    six
  ];

  meta = with stdenv.lib; {
    description = "An interactive command-line HTTP client featuring autocomplete and syntax highlighting";
    homepage = "https://github.com/eliangcs/http-prompt";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux; # can only test on linux
  };
}
