{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "gopass-hibp";
  version = "1.15.9";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-hibp";
    rev = "v${version}";
    hash = "sha256-ngLtxzRupvQF5BERdHhq+Ywf8F2rBpBSx/eH/JgA+IY=";
  };

  vendorHash = "sha256-yvimjsDaEXXLBUHtCovNSz4GUQ9TlvAogMgw+HSX0Mg=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
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
