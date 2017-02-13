{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "consul-template-${version}";
  version = "0.18.0";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/consul-template";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "consul-template";
    sha256 = "1a1r7jwv0d4l8bcjal9chvr871hmw0ljbihgjqasp6gvjg0hfbx6";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/hashicorp/consul-template/;
    description = "Generic template rendering and notifications with Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
