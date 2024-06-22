{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "pocketbase";
  version = "0.22.13";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = "pocketbase";
    rev = "v${version}";
    hash = "sha256-eps1sLtE/yBLyq1iTzOWu+RqFAjAg4EXWV7QZnr2KjQ=";
  };

  vendorHash = "sha256-hxI/0ask3iQW0Ox+HuJ6Oi1jiHF/0NZ+L7cLJijqyyQ=";

  # This is the released subpackage from upstream repo
  subPackages = [ "examples/base" ];

  CGO_ENABLED = 0;

  # Upstream build instructions
  ldflags = [
    "-s"
    "-w"
    "-X github.com/pocketbase/pocketbase.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/base $out/bin/pocketbase
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Open Source realtime backend in 1 file";
    homepage = "https://github.com/pocketbase/pocketbase";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya thilobillerbeck ];
    mainProgram = "pocketbase";
  };
}
