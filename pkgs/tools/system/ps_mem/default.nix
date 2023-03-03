{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "ps_mem";
  version = "3.13";

  src = fetchFromGitHub {
    owner = "pixelb";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pgi9hvwfbkzvwicqlkwx4rwal1ikza018yxbwpnf7c80zw0zaw9";
  };

  meta = with lib; {
    description = "A utility to accurately report the in core memory usage for a program";
    homepage = "https://github.com/pixelb/ps_mem";
    license = licenses.lgpl21;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
