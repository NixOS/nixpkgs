{ stdenv, fetchFromGitHub, pythonPackages, httpie }:

pythonPackages.buildPythonApplication rec {
  version = "0.9.1";
  name = "http-prompt";

  src = fetchFromGitHub {
    rev = "v${version}";
    repo = "http-prompt";
    owner = "eliangcs";
    sha256 = "0s2syjjz5n7256a4hn8gv3xfr0zd3qqimf4w8l188dbfvx8b8s06";
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
