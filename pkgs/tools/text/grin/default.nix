{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  program = "grin";
  version = "1.2.1";
  name = "${program}-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "rkern";
    repo = program;
    rev = "8dd4b5309b3bc04fe9d3e71836420f7d8d4a293f";
    sha256 = "0vz2aahwdcy1296g4w3i79dkvmzk9jc2n2zmlcvlg5m3s6h7b6jd";
  };

  buildInputs = with python2Packages; [ nose ];

  meta = {
    homepage = https://github.com/rkern/grin;
    description = "A grep program configured the way I like it";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.sjagoe ];
  };
}
