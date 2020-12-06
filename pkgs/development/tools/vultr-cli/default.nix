{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vultr-cli";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "vultr";
    repo = pname;
    rev = "v${version}";
    sha256 = "05qxbqq9mlq2jmyj5m9vmgw6s6a3wj06hmxj74g9lgqg8xyfglnh";
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
