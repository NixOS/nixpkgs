{ stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  name = "bunny-${version}";
  version = "1.1";

  src = fetchFromGitLab {
    owner = "tim241";
    repo = "bunny";
    rev = version;
    sha256 = "0mxhj23fscbyqb9hfpmimgjn6nbx1lx3dl2msgwdy281zs25w8ki";
  };

  dontBuild = true;

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A simple shell script wrapper around multiple package managers";
    homepage = https://gitlab.com/tim241/bunny;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ countingsort ];
  };
}
