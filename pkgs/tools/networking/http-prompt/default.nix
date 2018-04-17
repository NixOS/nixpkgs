{ stdenv, fetchFromGitHub, pythonPackages, httpie }:

pythonPackages.buildPythonApplication rec {
  version = "0.11.1";
  name = "http-prompt";

  src = fetchFromGitHub {
    rev = "v${version}";
    repo = "http-prompt";
    owner = "eliangcs";
    sha256 = "0gi76wcn6lxkd74ljpbyhr7ylhq6sm8z7h66dnfmpsw4nhw49178";
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
    $out/bin/${name} --version | grep -q "${version}"
  '';

  meta = with stdenv.lib; {
    description = "An interactive command-line HTTP client featuring autocomplete and syntax highlighting";
    homepage = https://github.com/eliangcs/http-prompt;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux; # can only test on linux
  };
}
