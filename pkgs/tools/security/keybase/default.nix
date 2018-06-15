{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "keybase-${version}";
  version = "2.0.0";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner  = "keybase";
    repo   = "client";
    rev    = "v${version}";
    sha256 = "0lapcw9csr18n4pc1mlljs1bd8w8imzsic4qgr07s53i80bd8l6n";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ carlsverre np rvolosatovs ];
  };
}
