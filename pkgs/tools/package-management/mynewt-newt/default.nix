{ stdenv, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "mynewt-newt";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "mynewt-newt";
    rev = "mynewt_${builtins.replaceStrings ["."] ["_"] version}_tag";
    sha256 = "0rwn4ghh7kal8csxlh0w1p29b5m1nam9lkrxla5wdfhnzbsg8hfa";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/apache/mynewt-newt/commit/6a51e35565323ebe8feb8d1aa6e00960b6ce662e.patch;
      sha256 = "186yha60jzcjq8r04w12rqqh3cin2w974l77hz2ixhmjzyr56wqv";
    })
    (fetchpatch {
      url = https://github.com/apache/mynewt-newt/commit/7d4ef3fe65a9a83cc58e7bd973654ad235cc68bc.patch;
      sha256 = "01scmq58bfr4c9icqzm79q7a55izflsb3mlx9xn0dv92m3mbprx7";
    })
  ];

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
