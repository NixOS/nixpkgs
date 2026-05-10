{ lib, fetchFromGitHub }:
let
  version = "3.14.0";
  vendorHash = "sha256-fibx+Ky2cfP71tPzeiDybx+0f/+XvZbDXC7PAWQMRIY=";
  nodeModulesHash = "sha256-wQUOUB5uhWbdEP1nP02ihRZf3F1sEvQeZTDxOa5P1lQ=";
in
{
  inherit version vendorHash nodeModulesHash;

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    tag = "v${version}";
    hash = "sha256-FFGNjQa4W6T1BmbNh3rD1m7vtJFBWmgxocRV+OO5ZfA=";
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
