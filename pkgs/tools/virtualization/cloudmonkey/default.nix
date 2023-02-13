{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "cloudmonkey";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "cloudstack-cloudmonkey";
    rev = version;
    sha256 = "sha256-C9e2KsnoggjWZp8gx757MbFdGxmfh+TtAd+luS3ycHU=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "CLI for Apache CloudStack";
    homepage = "https://github.com/apache/cloudstack-cloudmonkey";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
    mainProgram = "cloudstack-cloudmonkey";
  };

}
