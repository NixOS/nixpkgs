{ stdenv, fetchurl }: let
  version = "1.1.0";
in stdenv.mkDerivation {
  name = "long-shebang-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/long-shebang/releases/download/v${version}/long-shebang-${version}.tar.xz";
    sha256 = "0rlyibf7pczjfsi91nl1n5vri2vqibmvyyy070jaw3wb0wjm565a";
  };

  meta = {
    description = "A tool for #! scripts with more than one argument";

    homepage = https://github.com/shlevy/long-shebang;

    license = stdenv.lib.licenses.mit;

    platforms = stdenv.lib.platforms.unix;
  };
}
