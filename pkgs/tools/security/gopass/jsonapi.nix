{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, installShellFiles
, gopass
}:

buildGoModule rec {
  pname = "gopass-jsonapi";
  version = "1.15.14";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-jsonapi";
    rev = "v${version}";
    hash = "sha256-DbfmjgIUqgWVYyPqkcaeE5JKzqElNbrGnx62Fd8v7Hg=";
  };

  vendorHash = "sha256-Aahu0afi6bPnvz/NSZznbp0y9vMJWDj1Bq7tWGRmm7g=";

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
