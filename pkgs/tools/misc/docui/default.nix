{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "docui-${version}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "docui";
    rev = version;
    sha256 = "1kbap36hccwlj273is98cvgf5z5cl2c3s6p46nh6bnykz3zqzs71";
  };

  modSha256 = "1qma9bnd4k594cr5dcv74xns53mhfyl4jsm01chf85dxywjjd9vd";

  meta = with stdenv.lib; {
    description = "TUI Client for Docker";
    homepage = https://github.com/skanehira/docui;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
