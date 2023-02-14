{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "git-credential-gopass";
  version = "1.15.4";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "git-credential-gopass";
    rev = "v${version}";
    hash = "sha256-S97KQ/yCyE1wBDao5KBKWPvoH+DmwpEJRiB6uJCGyFA=";
  };

  vendorHash = "sha256-MLnfTdYR4/1qtnNCUs0TwGf5wMqE+V8jNCefeClQKfw=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/git-credential-gopass \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Manage git credentials using gopass";
    homepage = "https://github.com/gopasspw/git-credential-gopass";
    license = licenses.mit;
    maintainers = with maintainers; [ benneti ];
  };
}
