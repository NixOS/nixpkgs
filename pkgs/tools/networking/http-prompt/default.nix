{ stdenv, fetchFromGitHub, pythonPackages, httpie }:

pythonPackages.buildPythonApplication rec {
  version = "0.10.2";
  name = "http-prompt";

  src = fetchFromGitHub {
    rev = "v${version}";
    repo = "http-prompt";
    owner = "eliangcs";
    sha256 = "0c03n1ll61zd4f60kzih3skl0hspck5hhpcf74h5l6v5as7qdbi2";
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
    homepage = https://github.com/eliangcs/http-prompt;
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux; # can only test on linux
  };
}
