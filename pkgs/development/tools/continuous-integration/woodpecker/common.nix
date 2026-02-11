{ lib, fetchFromGitHub }:
let
  version = "3.13.0";
  vendorHash = "sha256-EkOg1D+zeEbVBPr4fpCPI31CvMnTD7FZ2hhQW7UzN8A=";
  nodeModulesHash = "sha256-wORM+24nE771llb1Q7bn6iDtlJpm3kOqO3wTLUQmjyQ=";
in
{
  inherit version vendorHash nodeModulesHash;

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    tag = "v${version}";
    hash = "sha256-EeND2L5l37fo3JBlFORR4m0tXQWlJ2qqIXIdQ1vJdgM=";
  };

  postInstall = ''
    cd $out/bin
    for f in *; do
      if [ "$f" = cli ]; then
        # Issue a warning to the user if they call the deprecated executable
        cat >woodpecker << EOF
    #!/bin/sh
    echo 'WARNING: calling \`woodpecker\` is deprecated, use \`woodpecker-cli\` instead.' >&2
    $out/bin/woodpecker-cli "\$@"
    EOF
        chmod +x woodpecker
        patchShebangs woodpecker
      fi
        mv -- "$f" "woodpecker-$f"
    done
    cd -
  '';

  ldflags = [
    "-s"
    "-w"
    "-X go.woodpecker-ci.org/woodpecker/v3/version.Version=${version}"
  ];

  meta = {
    homepage = "https://woodpecker-ci.org/";
    changelog = "https://github.com/woodpecker-ci/woodpecker/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ambroisie
      marcusramberg
      techknowlogick
    ];
  };
}
