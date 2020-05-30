{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z3vbcpchrf3bak08p72c96c2l39hdp196fqc5wvsqar3mzrrz7s";
  };

  vendorSha256 = null;

  meta = with stdenv.lib; {
    description = "Official command line tool for Vultr services";
    homepage = "https://github.com/vultr/vultr-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
