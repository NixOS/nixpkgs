{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "mynewt-newt-${version}";
  version = "1.0.0";

  goPackagePath = "mynewt.apache.org/newt";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-mynewt-newt";
    rev = "mynewt_${builtins.replaceStrings ["."] ["_"] version}_tag";
    sha256 = "1ixqxqizd957prd4j2nijgnkv84rffj8cx5f7aqyjq9nkawjksf6";
  };

  meta = with stdenv.lib; {
    homepage = https://mynewt.apache.org/;
    description = "Build and package management tool for embedded development.";
    longDescription = ''
      Apache Newt is a smart build and package management tool,
      designed for C and C++ applications in embedded contexts. Newt
      was developed as a part of the Apache Mynewt Operating System.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ pjones ];
    platforms = platforms.linux;
  };
}
