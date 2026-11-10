{ lib, fetchFromGitHub }:
let
  version = "3.20.1";
  vendorHash = "sha256-FUHqdjuOv+ojg686YfQ6YdAdXivYvHOW0iM4h5I4Wdc=";
  nodeModulesHash = "sha256-x0hwU8hlUMQ1AH9dz0G1sKoXYLSMKI8wNq7hE0CrJ+M=";
in
{
  inherit version vendorHash nodeModulesHash;

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    tag = "v${version}";
    hash = "sha256-vGAgZKz0zWS+xXid2uJUjbLnCB40TTg2KRT3cuWAR6Y=";
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
