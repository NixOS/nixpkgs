{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "keybase-${version}";
  version = "1.0.17";
  rev = "v${version}";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    inherit rev;
    sha256 = "14cj0npsvnc3whw7gashgd7lhj3lvjdkivsnvsjg7dp3hifvqxnx";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux;
    maintainers = with maintainers; [ carlsverre ];
  };
}
