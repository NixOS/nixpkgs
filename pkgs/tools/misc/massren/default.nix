{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "massren";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "laurent22";
    repo = "massren";
    rev = "v${version}";
    hash = "sha256-17y+vmspvZKKRRaEwzP3Zya4r/z+2aSGG6oNZiA8D64=";
  };

  vendorHash = null;

  patches = [
    # Add Go Modules support
    (fetchpatch {
      url = "https://github.com/laurent22/massren/commit/83df215b6e112d1ec375b08d8c44dadc5107155d.patch";
      hash = "sha256-FMTmUrv6zGq11vexUirAuK3H6r78RtoipqyWoh+pzrs=";
    })
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        # Possible error about github.com/mattn/go-sqlite3
        "Test_guessEditorCommand"
        "Test_processFileActions"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = with lib; {
    description = "Easily rename multiple files using your text editor";
    license = licenses.mit;
    homepage = "https://github.com/laurent22/massren";
    maintainers = with maintainers; [ ];
    mainProgram = "massren";
  };
}
