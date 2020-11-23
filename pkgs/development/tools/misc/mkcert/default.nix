{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mkcert";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g85vpkfgkc7nzjl3asl2f4ncsh12naf2fkr0mvyihfmfy9fz0fw";
  };

  vendorSha256 = "0b8ggdpbyxx5n2myhchhlwmm5nndwpykp1ylnzdyw12mdskfvn9h";

  doCheck = false;

  buildFlagsArray = ''
    -ldflags=-s -w -X main.Version=v${version}
  '';

  meta = with lib; {
    homepage = "https://github.com/FiloSottile/mkcert";
    description = "A simple tool for making locally-trusted development certificates";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
