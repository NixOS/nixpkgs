{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, fetchpatch
, gopass
}:

buildGoModule rec {
  pname = "gopass-summon-provider";
  version = "1.15.12";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-summon-provider";
    rev = "v${version}";
    hash = "sha256-gvgHqeVB+4d8UJhMv3CYYidttCcaRPkgI7PXasv7pCI=";
  };

  patches = [
    # go mod tidy. Remove with next release
    (fetchpatch {
      url = "https://github.com/gopasspw/gopass-summon-provider/commit/b3085cab14588cb6a5a383033947d9266fe0cd56.patch";
      hash = "sha256-8mvJqejqmuOloj9mW9zzsE/Xr0DtPhJeDItzVFVv4+c=";
    })
  ];

  vendorHash = "sha256-y1PH0+tt/kcHw2I4LWD2XfLud3JtsYqrRd/yVRPdaTA=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-summon-provider \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Gopass Summon Provider";
    homepage = "https://github.com/gopasspw/gopass-summon-provider";
    changelog = "https://github.com/gopasspw/gopass-summon-provider/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "gopass-summon-provider";
  };
}
