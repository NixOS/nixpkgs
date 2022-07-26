{ lib, stdenv, buildGoPackage, fetchFromGitHub, pkg-config, pcsclite }:

buildGoPackage rec {
  pname = "keycard-cli";
  version = "0.6.0";

  goPackagePath = "github.com/status-im/keycard-cli";
  subPackages = [ "." ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcsclite ];

  src = fetchFromGitHub {
    owner = "status-im";
    repo = pname;
    rev = version;
    sha256 = "sha256-ejFvduZs3eWc6efr9o4pXb6qw2QWWQTtkTxF80vOGNU=";
  };

  ldflags = [
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "A command line tool and shell to manage keycards";
    homepage = "https://keycard.status.im";
    license = licenses.mpl20;
    maintainers = [ maintainers.zimbatm ];
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/keycard-cli.x86_64-darwin
  };
}
