{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "up";
  version = "0.3.2";

  patches = [ ./gomod.patch ];

  src = fetchFromGitHub {
    owner = "akavel";
    repo = "up";
    rev = "v${version}";
    sha256 = "1psixyymk98z52yy92lwb75yfins45dw6rif9cxwd7yiascwg2if";
  };

  vendorSha256 = "1h3w4i7dyh6yagqmdclvflfq6fx0z880jdnpf28assv7fxd9rjsx";

  meta = with lib; {
    description = "Ultimate Plumber is a tool for writing Linux pipes with instant live preview";
    homepage = "https://github.com/akavel/up";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.asl20;
  };
}
