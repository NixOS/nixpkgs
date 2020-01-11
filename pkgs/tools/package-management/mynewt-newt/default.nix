{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mynewt-newt";
  version = "1.3.0";

  goPackagePath = "mynewt.apache.org/newt";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-mynewt-newt";
    rev = "mynewt_${builtins.replaceStrings ["."] ["_"] version}_tag";
    sha256 = "0ia6q1wf3ki2yw8ngw5gnbdrb7268qwi078j05f8gs1sppb3g563";
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
    platforms = platforms.unix;
  };
}
