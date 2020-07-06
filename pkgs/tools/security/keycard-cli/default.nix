{ lib, buildGoPackage, fetchFromGitHub, pkgconfig, pcsclite }:

buildGoPackage rec {
  pname = "keycard-cli";
  version = "0.4.0";

  goPackagePath = "github.com/status-im/keycard-cli";
  subPackages = [ "." ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pcsclite ];

  src = fetchFromGitHub {
    owner = "status-im";
    repo = pname;
    rev = version;
    sha256 = "0917vl5lw8wgvyn5l8q6xa8bqh342fibaa38syr8hmz8b09qkh38";
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
