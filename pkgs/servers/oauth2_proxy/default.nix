{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "oauth2_proxy";
  version = "3.2.0";
  
  goPackagePath = "github.com/pusher/${pname}";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pusher";
    sha256 = "0k73ggyh12g2vzjq91i9d3bxbqfvh5k6njzza1lvkzasgp07wisg";
    rev = "v${version}";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A reverse proxy that provides authentication with Google, Github or other provider";
    homepage = https://github.com/pusher/oauth2_proxy/;
    license = licenses.mit;
    maintainers = [ maintainers.yorickvp ];
  };
}
