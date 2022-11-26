{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "git-credential-gopass";
  version = "1.14.11";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JA5VpiImpdxdGSnuzXDBPW8JiLspEhjeR+rlfN41BBM=";
  };

  vendorHash = "sha256-6GRK1M358LC6S/sjiN42+whz1Z3S+PRKyPOZr8n+daQ=";

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
