{ stdenv, pythonPackages, fetchFromGitHub }:

let
  version = "3.12";
  pname = "ps_mem";
in pythonPackages.buildPythonApplication rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "pixelb";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0kcxlmfisbwf24p2k72njfyfp22fjr9p9zalg9b4w0yhnlzk24ph";
  };

  meta = with stdenv.lib; {
    description = "A utility to accurately report the in core memory usage for a program";
    homepage = https://github.com/pixelb/ps_mem;
    license = licenses.lgpl21;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
