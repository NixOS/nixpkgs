{ stdenv, fetchFromGitHub, pythonPackages, httpie }:

pythonPackages.buildPythonApplication rec {
  pname = "http-prompt";
  version = "1.0.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    repo = "http-prompt";
    owner = "eliangcs";
    sha256 = "0kngz2izcqjphbrdkg489p0xmf65xjc8ki1a2szcc8sgwc7z74xy";
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
