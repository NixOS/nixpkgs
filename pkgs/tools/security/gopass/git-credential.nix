{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "git-credential-gopass";
  version = "1.14.7";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wxaghZth3soT1r7Hh9oYoyhE0pslo1HPUv2TEvZpMrU==";
  };

  vendorHash = "sha256-K6nYgy+fLvMQCse3CN8sGBkTW6fw1eSN5TjEOzzOToY=";

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
