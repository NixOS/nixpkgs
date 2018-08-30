{ stdenv, fetchFromGitHub, pythonPackages, httpie }:

pythonPackages.buildPythonApplication rec {
  pname = "http-prompt";
  version = "0.11.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    repo = "http-prompt";
    owner = "eliangcs";
    sha256 = "130w3wkb5jbiwm5w0b470nd50gf30vrknmf3knhlgdxdmfb30zjz";
  };

  propagatedBuildInputs = with pythonPackages; [
    click
    httpie
    parsimonious
    prompt_toolkit
    pygments
    six
  ];

  checkPhase = ''
    $out/bin/${pname} --version | grep -q "${version}"
  '';

  meta = with stdenv.lib; {
    description = "An interactive command-line HTTP client featuring autocomplete and syntax highlighting";
    homepage = https://github.com/eliangcs/http-prompt;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux; # can only test on linux
  };
}
