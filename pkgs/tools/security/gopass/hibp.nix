{
  lib,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  gopass,
}:

buildGoModule rec {
  pname = "gopass-hibp";
  version = "1.15.17";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-hibp";
    rev = "v${version}";
    hash = "sha256-MUC9eYpm+1inkJtTmXxfS3bTMcsQCZlpNhqlq0p7fEY=";
  };

  vendorHash = "sha256-58coZrNZdCK3R5EeJ/xQbRr94Y4ugufjrkaoeQgN1YY=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-hibp \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Gopass haveibeenpwnd.com integration";
    homepage = "https://github.com/gopasspw/gopass-hibp";
    changelog = "https://github.com/gopasspw/gopass-hibp/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "gopass-hibp";
  };
}
