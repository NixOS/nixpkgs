{ lib, fetchzip }:
let
  version = "2.7.3";
  srcHash = "sha256-ut5F2KZlWkJeAiLv2z9WmSoUoXxbzCXCgmZiwtX0f+U=";
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
      if [ "$f" = cli ]; then
        mv -- "$f" "woodpecker"
        # Issue a warning to the user if they call the deprecated executable
        cat >woodpecker-cli << EOF
    #!/bin/sh
    echo 'WARNING: calling \`woodpecker-cli\` is deprecated, use \`woodpecker\` instead.' >&2
    $out/bin/woodpecker "\$@"
    EOF
        chmod +x woodpecker-cli
        patchShebangs woodpecker-cli
      else
        mv -- "$f" "woodpecker-$f"
      fi
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
