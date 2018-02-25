{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "keybase-${version}";
  version = "1.0.42";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner  = "keybase";
    repo   = "client";
    rev    = "v${version}";
    sha256 = "0vjwyg542hiswcs89csh2vbkfyixlzk3zswjn7x7d1pifrckys0r";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ carlsverre np rvolosatovs ];
  };
}
