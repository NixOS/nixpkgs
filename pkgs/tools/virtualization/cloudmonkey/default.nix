{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "cloudmonkey";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "cloudstack-cloudmonkey";
    rev = version;
    sha256 = "sha256-OmVM6ayrtrLl+PADnkUnrssbsq1GZp2KiMBOXPgfi5Y=";
  };

  runVend = true;

  vendorSha256 = null;

  meta = with lib; {
    description = "CLI for Apache CloudStack";
    homepage = "https://github.com/apache/cloudstack-cloudmonkey";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };

}
