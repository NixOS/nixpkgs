{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1604l36y6pggk72x4avdijq7c90w0as7xamh634a68ymjnd10jv4";
  };

  vendorSha256 = null;

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Official command line tool for Vultr services";
    homepage = "https://github.com/vultr/vultr-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
