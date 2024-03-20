{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, fetchpatch
, gopass
}:

buildGoModule rec {
  pname = "git-credential-gopass";
  version = "1.15.12";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "git-credential-gopass";
    rev = "v${version}";
    hash = "sha256-5j5+so4LT3x+epEZf9OVn/kLNHBk2ENQxxRrzbziEA4=";
  };

  patches = [
    # go mod tidy. Remove with next release
    (fetchpatch {
      url = "https://github.com/gopasspw/git-credential-gopass/commit/88d11d2b1b49f00b7fba9a917cf90f7ea14c9d1b.patch";
      hash = "sha256-mXxI9GXan0zYL8msL83VLqxOp4oAOwMyCOFaUOLAg5E=";
    })
  ];

  vendorHash = "sha256-y1PH0+tt/kcHw2I4LWD2XfLud3JtsYqrRd/yVRPdaTA=";

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
    changelog = "https://github.com/gopasspw/git-credential-gopass/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ benneti ];
    mainProgram = "git-credential-gopass";
  };
}
