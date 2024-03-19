{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, fetchpatch
, installShellFiles
, gopass
}:

buildGoModule rec {
  pname = "gopass-jsonapi";
  version = "1.15.12";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-jsonapi";
    rev = "v${version}";
    hash = "sha256-sR+48MRBHj3XpKLp/AOGf2H4ltZD1fHlIA2HPYSHdp0=";
  };

  patches = [
    # go mod tidy. Remove with next release
    (fetchpatch {
      url = "https://github.com/gopasspw/gopass-jsonapi/commit/cab33faab113d0c9702ebaa14cde13e5ccd465d2.patch";
      hash = "sha256-IoxU5r1k0Y6N+PKAZH8LEO/fXHjryx5y58RRFeHP7Bc=";
    })
  ];

  vendorHash = "sha256-2JADTyBgAK2j524G+ksKLJC255PmvMViFFCwmgtXZzA=";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-jsonapi \
      --prefix PATH : "${gopass.wrapperPath}"
  '';

  meta = with lib; {
    description = "Enables communication with gopass via JSON messages";
    homepage = "https://github.com/gopasspw/gopass-jsonapi";
    changelog = "https://github.com/gopasspw/gopass-jsonapi/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxhbr ];
    mainProgram = "gopass-jsonapi";
  };
}
