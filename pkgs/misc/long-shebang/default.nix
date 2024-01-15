{ lib, stdenv, fetchurl }: let
  version = "1.2.0";
in stdenv.mkDerivation {
  pname = "long-shebang";
  inherit version;

  src = fetchurl {
    url = "https://github.com/shlevy/long-shebang/releases/download/v${version}/long-shebang-${version}.tar.xz";
    sha256 = "10h29w1c5bm0rlscyjiz1kzb134rn92as6v4y7i8mhhmdh6mmf79";
  };

  meta = {
    description = "A tool for #! scripts with more than one argument";

    homepage = "https://github.com/shlevy/long-shebang";

    license = lib.licenses.mit;

    platforms = lib.platforms.unix;
    mainProgram = "long-shebang";
  };
}
