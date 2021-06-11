{ lib, fetchFromGitHub, buildGoModule }:

with lib;

buildGoModule rec {
  pname = "butane";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "butane";
    rev = "v${version}";
    sha256 = "0wjnzxjv71pmn88f6fm20xhsmdib6jwn9839n1xw9px9w95qg0yy";
  };

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "internal" ];

  buildFlagsArray = ''
    -ldflags=-X github.com/coreos/butane/internal/version.Raw=v${version}
  '';

  postInstall = ''
    mv $out/bin/{internal,butane}
  '';

  meta = {
    description = "Translates human-readable Butane configs into machine-readable Ignition configs";
    license = licenses.asl20;
    homepage = "https://github.com/coreos/butane";
    maintainers = with maintainers; [ elijahcaine ruuda ];
    platforms = platforms.unix;
  };
}
