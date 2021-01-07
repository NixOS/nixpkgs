{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "consul-template";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    sha256 = "1205rhv4mizpb1nbc2sry52n7wljcwb8xp7lpazh1r1cldfayr5b";
  };

  vendorSha256 = "0hv4b6k8k7xkzkjgzcm5y8pqyiwyk790a1qw18gjslkwkyw5hjf2";

  # consul-template tests depend on vault and consul services running to
  # execute tests so we skip them here
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/hashicorp/consul-template/";
    description = "Generic template rendering and notifications with Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud pradeepchhetri ];
  };
}
