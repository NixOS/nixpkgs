{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "oauth2_proxy-${version}";
  version = "20180325-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "a94b0a8b25e553f7333f7b84aeb89d9d18ec259b";
  
  goPackagePath = "github.com/bitly/oauth2_proxy";

  src = fetchFromGitHub {
    inherit rev;
    repo = "oauth2_proxy";
    owner = "bitly";
    sha256 = "07m258s9fxjsgixggw0d1zicd7l6l2rkm5mh3zdjdaj20sqcj217";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github or other provider";
    homepage = https://github.com/bitly/oauth2_proxy/;
    license = licenses.mit;
    maintainers = [ maintainers.yorickvp ];
  };
}
