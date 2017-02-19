{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "keybase-${version}";
  version = "20170209.17b641d";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "17b641de629a85ad77621d0efa3e2442661b5ee7";
    sha256 = "0y6kiwj690yd0alvcyd74wx2wlbh110k1rdcvimszyb9gqig8p11";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux;
    maintainers = with maintainers; [ carlsverre ];
  };
}
