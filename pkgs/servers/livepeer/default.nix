{ lib, stdenv, fetchFromGitHub, buildGoModule
, pkg-config, ffmpeg, gnutls
}:

buildGoModule rec {
  pname = "livepeer";
  version = "0.5.13";

  runVend = true;
  vendorSha256 = "sha256-wAjGgYDyBWqE8KCQ6TQ+LGDDZqF+5XY+NzU74RwPuRE=";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    rev = "v${version}";
    sha256 = "sha256-b4O8Hc8A8TN5KFcQ7KYvFPVFgposDgPw06WowrXzpAs=";
  };

  # livepeer_cli has a vendoring problem
  subPackages = [ "cmd/livepeer" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ffmpeg gnutls ];

  meta = with lib; {
    description = "Official Go implementation of the Livepeer protocol";
    homepage = "https://livepeer.org";
    license = licenses.mit;
    maintainers = with maintainers; [ elitak ];
  };
}
