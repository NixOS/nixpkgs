{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kcli";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "cswank";
    repo = "kcli";
    rev = version;
    sha256 = "0whijr2r2j5bvfy8jgmpxsa0zvwk5kfjlpnkw4za5k35q7bjffls";
  };

  vendorHash = null;

  subPackages = [ "." ];

  meta = with lib; {
    description = "A kafka command line browser";
    homepage = "https://github.com/cswank/kcli";
    license = licenses.mit;
    maintainers = with maintainers; [ cswank ];
    broken = true; # vendor isn't reproducible with go > 1.17: nix-build -A $name.goModules --check
  };
}
