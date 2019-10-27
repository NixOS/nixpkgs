{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

python3Packages.buildPythonApplication rec {
  pname = "asciinema";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
    rev = "v${version}";
    sha256 = "1a2pysxnp6icyd08mgf66xr6f6j0irnfxdpf3fmzcz31ix7l9kc4";
  };

  checkInputs = [ glibcLocales python3Packages.nose ];

  checkPhase = ''
    LC_ALL=en_US.UTF-8 nosetests
  '';

  meta = {
    description = "Terminal session recorder and the best companion of asciinema.org";
    homepage = https://asciinema.org/;
    license = with lib.licenses; [ gpl3 ];
  };
}

