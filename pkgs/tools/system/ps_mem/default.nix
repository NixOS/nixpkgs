{ stdenv, pythonPackages, fetchFromGitHub }:

let
  version = "3.13";
  pname = "ps_mem";
in pythonPackages.buildPythonApplication {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "pixelb";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pgi9hvwfbkzvwicqlkwx4rwal1ikza018yxbwpnf7c80zw0zaw9";
  };

  meta = with stdenv.lib; {
    description = "A utility to accurately report the in core memory usage for a program";
    homepage = https://github.com/pixelb/ps_mem;
    license = licenses.lgpl21;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
