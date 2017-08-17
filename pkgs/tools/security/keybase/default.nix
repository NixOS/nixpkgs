{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "keybase-${version}";
  version = "1.0.27";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner  = "keybase";
    repo   = "client";
    rev    = "v${version}";
    sha256 = "0s68awgaq32hl5rvcrnhn9i98dwh23kws0l4czcghyn6imx8h89i";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux;
    maintainers = with maintainers; [ carlsverre np ];
  };
}
