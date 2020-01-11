{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mynewt-newt";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "mynewt-newt";
    rev = "mynewt_${builtins.replaceStrings ["."] ["_"] version}_tag";
    sha256 = "0rwn4ghh7kal8csxlh0w1p29b5m1nam9lkrxla5wdfhnzbsg8hfa";
  };

  modSha256 = "068r8wa2pgd68jv50x0l1w8n96f97b3mgv7z6f85280ahgywaasq";

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
