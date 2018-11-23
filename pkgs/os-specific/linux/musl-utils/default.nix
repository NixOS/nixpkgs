{ stdenv, lib, musl, fetchFromGitHub, ... }:

with lib;

# let
#   getent_c = builtins.fetchurl {
#     url = https://raw.githubusercontent.com/alpinelinux/aports/89a718d88ec7466e721f3bbe9ede5ffe58061d78/main/musl/getent.c;
#     sha256 = "0b4jqnsmv1hjgcz7db3vd61k682aphl59c3yhwya2q7mkc6g48xk";
#   };

#   getconf_c = builtins.fetchurl {
#     url = https://raw.githubusercontent.com/alpinelinux/aports/89a718d88ec7466e721f3bbe9ede5ffe58061d78/main/musl/getconf.c;
#     sha256 = "0z14ml5343p5gapxw9fnbn2r72r7v2gk8662iifjrblh6sxhqzfq";
#   };

#   iconv_c = builtins.fetchurl {
#     url = https://raw.githubusercontent.com/alpinelinux/aports/89a718d88ec7466e721f3bbe9ede5ffe58061d78/main/musl/iconv.c;
#     sha256 = "1mzxnc2ncq8lw9x6n7p00fvfklc9p3wfv28m68j0dfz5l8q2k6pp";
#   };

# in
 stdenv.mkDerivation rec {
  name = "musl-utils-${version}";
  version = "1.1.20";

  src = fetchFromGitHub {
    owner = "alpinelinux";
    repo = "aports";
    rev = "89a718d88ec7466e721f3bbe9ede5ffe58061d78";
    sha256 = "1jvany3fpywgblr3n5swqk1q0hxnilv0js4rvwhns48llamyn64n";
  };

  buildInputs = [ musl ];

  unpackPhase = "true";

  configurePhase = "true";

  buildPhase = ''
     ${getBin stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc $src/main/musl/getent.c -o getent
     ${getBin stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc $src/main/musl/getconf.c -o getconf
     ${getBin stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc $src/main/musl/iconv.c -o iconv
  '';

  installPhase = ''
     mkdir -p $out/bin
     cp getent $out/bin/getent
     cp getconf $out/bin/getconf
     cp iconv $out/bin/iconv
     ln -s ${musl}/lib/libc.so $out/bin/ldd
  '';
}
