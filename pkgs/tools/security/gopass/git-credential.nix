{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "git-credential-gopass";
  version = "1.14.6";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sguhKK3YBVitv4/tFLZtto2ZgUXWDdCKMksKC3zVgrY=";
  };

  vendorSha256 = "sha256-OADJVtnggv3y5tjyiJxhKQsWs0svLN63M1wCOqBEKpU=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/git-credential-gopass --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Manage git credentials using gopass";
    homepage = "https://github.com/gopasspw/git-credential-gopass";
    license = licenses.mit;
    maintainers = with maintainers; [ benneti ];
  };
}
