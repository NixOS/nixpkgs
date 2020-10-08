{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gp1v62iqh3hk46cc5sh8a1nw5nf98m969fdhgxdppwr5dhj9isp";
  };

  vendorSha256 = null;

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Official command line tool for Vultr services";
    homepage = "https://github.com/vultr/vultr-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
