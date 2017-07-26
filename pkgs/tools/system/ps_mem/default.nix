{ stdenv, pythonPackages, fetchFromGitHub }:

let
  version = "3.9";
  pname = "ps_mem";
in pythonPackages.buildPythonApplication rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "pixelb";
    repo = "${pname}";
    rev = "f0891def54f1edb78a70006603d2b025236b830f";
    sha256 = "1vy0z5nhia61hpqndf7kkjm12mgi0kh33jx5g1glggy45ymcisif";
  };

  meta = with stdenv.lib; {
    description = "A utility to accurately report the in core memory usage for a program";
    homepage = https://github.com/pixelb/ps_mem;
    license = licenses.lgpl21;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
