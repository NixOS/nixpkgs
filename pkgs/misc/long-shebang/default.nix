{ stdenv, fetchurl }: let
  version = "1.0.0";
in stdenv.mkDerivation {
  name = "long-shebang-${version}";

  src = fetchurl {
    url = "https://github.com/shlevy/long-shebang/releases/download/v1.0.0/long-shebang-1.0.0.tar.xz";
    sha256 = "15f5rmihj3r53rmalix1bn1agybbzrc3g2a9xzjyd4v3vfd2vckr";
  };

  meta = {
    description = "A tool for #! scripts with more than one argument";

    homepage = https://github.com/shlevy/long-shebang;

    license = stdenv.lib.licenses.mit;

    platforms = stdenv.lib.platforms.unix;
  };
}
