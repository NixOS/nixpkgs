{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vwv6gkzrs5nv5a278siwza2ifwqy08rmcdddx275crcjkz3bv53";
  };

  modSha256 = "048mh6zr1fkz5bcxg27d0s472ig9xcq0zgbqpxspkvkdxxw9iizf";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
