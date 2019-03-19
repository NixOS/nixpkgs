{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "nsq-${version}";
  version = "1.1.0";
  rev = "v${version}";

  goPackagePath = "github.com/nsqio/nsq";

  src = fetchFromGitHub {
    inherit rev;
    owner = "nsqio";
    repo = "nsq";
    sha256 = "1yl4nnis1ghnhpzaww2irvz22k5p6wvlslsxfmpwk6s0zgdvrk4n";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = https://nsq.io/;
    description = "A realtime distributed messaging platform";
    license = licenses.mit;
    maintainers = with maintainers; [ pjones ];
  };
}
