{ stdenv, fetchurl }: let
  version = "1.0.1";
in stdenv.mkDerivation {
  name = "long-shebang-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/long-shebang/releases/download/v${version}/long-shebang-${version}.tar.xz";
    sha256 = "0kj299f3a9zawi96fmw1iq6p6yg0pdm1wgmv61iw5w0zn9v4924b";
  };

  meta = {
    description = "A tool for #! scripts with more than one argument";

    homepage = https://github.com/shlevy/long-shebang;

    license = stdenv.lib.licenses.mit;

    platforms = stdenv.lib.platforms.unix;
  };
}
