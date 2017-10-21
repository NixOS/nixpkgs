{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-template-${version}";
  version = "0.18.1";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/consul-template";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "consul-template";
    sha256 = "0swyhc5smjbp5wql43qhpxrcbg47v89l5icb1s60gszhxizlkk7d";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/hashicorp/consul-template/;
    description = "Generic template rendering and notifications with Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
