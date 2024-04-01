{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, fetchpatch
, gopass
}:

buildGoModule rec {
  pname = "gopass-hibp";
  version = "1.15.12";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-hibp";
    rev = "v${version}";
    hash = "sha256-5BnCaxF2XZ4f26KsTbapcZ2+Ii58nR/14pCj0c0QLKE=";
  };

  patches = [
    # go mod tidy. Remove with next release
    (fetchpatch {
      url = "https://github.com/gopasspw/gopass-hibp/commit/cdfdbc6da154874c74d7c8fc83bb11a98dd8fd81.patch";
      hash = "sha256-jCzg3c8EizhoRYvWUZCys6/q2ChVWy/psPofNGIYdxs=";
    })
  ];

  vendorHash = "sha256-GLqtwUg3fa1okdPoQBkF+ygpm8GLmDyIyUiC7/TTTaE=";

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
