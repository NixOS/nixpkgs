{ stdenv, fetchgit, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "grin-1.2.1";
  namePrefix = "";

  src = fetchgit {
    url = "git://github.com/rkern/grin";
    rev = "8dd4b5309b3bc04fe9d3e71836420f7d8d4a293f";
    sha256 = "0vz2aahwdcy1296g4w3i79dkvmzk9jc2n2zmlcvlg5m3s6h7b6jd";
  };

  buildInputs = with python2Packages; [ nose ];

  meta = {
    homepage = https://pypi.python.org/pypi/grin;
    description = "A grep program configured the way I like it";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.sjagoe ];
  };
}
