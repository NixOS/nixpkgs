{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-template-${version}";
  version = "0.19.4";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/consul-template";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "consul-template";
    sha256 = "06agjzpax45gw7s9b69cz9w523nx7ksikqcg0z0vipwrp7pwrydd";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/hashicorp/consul-template/;
    description = "Generic template rendering and notifications with Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
