{ lib, buildGoPackage, fetchFromGitHub, pkgconfig, pcsclite }:

buildGoPackage rec {
  pname = "keycard-cli";
  version = "0.0.12";

  goPackagePath = "github.com/status-im/keycard-cli";
  subPackages = [ "." ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pcsclite ];

  src = fetchFromGitHub {
    owner = "status-im";
    repo = pname;
    rev = version;
    sha256 = "1jnbaq57i6i9bad1hcvd28mxfqq6v8rv806c6l74vlb79ff4v1wb";
  };

  buildFlagsArray = [
    "-ldflags="
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "A command line tool and shell to manage keycards";
    homepage = "https://keycard.status.im";
    license = licenses.mpl20;
    maintainers = [ maintainers.zimbatm ];
  };
}
