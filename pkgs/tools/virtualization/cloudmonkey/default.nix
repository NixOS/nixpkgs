{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "cloudmonkey";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "cloudstack-cloudmonkey";
    rev = version;
    sha256 = "sha256-FoouZ2udtZ68W5p32Svr8yAn0oBdWMupn1LEzqY04Oc=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "CLI for Apache CloudStack";
    homepage = "https://github.com/apache/cloudstack-cloudmonkey";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
    mainProgram = "cloudstack-cloudmonkey";
  };

}
