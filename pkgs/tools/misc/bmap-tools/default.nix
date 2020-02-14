{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "bmap-tools";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "bmap-tools";
    rev = "v${version}";
    sha256 = "0p0pdwvyf9b4czi1pnhclm1ih8kw78nk2sj4if5hwi7s5423wk5q";
  };

  meta = with stdenv.lib; {
    description = "bmap-related tools";
    homepage = https://github.com/intel/bmap-tools;
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
