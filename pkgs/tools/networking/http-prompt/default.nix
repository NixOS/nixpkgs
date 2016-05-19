{ pkgs, stdenv, fetchurl, buildPythonApplication, pythonPackages }:

buildPythonApplication rec {
  version = "0.1.1";
  name = "http-prompt";

  src = fetchurl {
    url = "https://github.com/eliangcs/http-prompt/archive/v${version}.tar.gz";
    sha256 = "1kzrg357vplfz5hk47inzfpqckf77jzbd2qlqakil8x5n7gz19mm";
  };

  propagatedBuildInputs = with pythonPackages; [
    click
    pkgs.httpie
    parsimonious
    prompt_toolkit
    pygments
    six
  ];

  meta = with stdenv.lib; {
    description = "an interactive command-line HTTP client featuring autocomplete and syntax highlighting";
    homepage = "https://github.com/eliangcs/http-prompt";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux; # can only test on linux
  };
}
