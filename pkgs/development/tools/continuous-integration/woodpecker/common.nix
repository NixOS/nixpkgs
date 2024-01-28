{ lib, fetchzip }:
let
  version = "2.2.2";
  srcHash = "sha256-Ld75U7ItpBgoLKPLNQF0Kb5PFg2O5vdm26aNs/HYfcw=";
  # The tarball contains vendored dependencies
  vendorHash = null;
in
{
  inherit version vendorHash;

  src = fetchzip {
    url = "https://github.com/woodpecker-ci/woodpecker/releases/download/v${version}/woodpecker-src.tar.gz";
    hash = srcHash;
    stripRoot = false;
  };

  postInstall = ''
    cd $out/bin
    for f in *; do
      mv -- "$f" "woodpecker-$f"
    done
    cd -
  '';

  ldflags = [
    "-s"
    "-w"
    "-X go.woodpecker-ci.org/woodpecker/v2/version.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://woodpecker-ci.org/";
    changelog = "https://github.com/woodpecker-ci/woodpecker/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie techknowlogick adamcstephens ];
  };
}
