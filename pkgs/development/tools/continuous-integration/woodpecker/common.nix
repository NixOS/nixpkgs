{ lib, fetchFromGitHub }:
let
  version = "3.12.0";
  vendorHash = "sha256-TXQ53G+YGIcURZvJtkvGU66dlQx0NxMTeRkrmReCDU8=";
  nodeModulesHash = "sha256-Mx5Q9Zdv4sJGRDs3dYio7IfktFvauLJqZxGBhOOjdo4=";
in
{
  inherit version vendorHash nodeModulesHash;

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    tag = "v${version}";
    hash = "sha256-TaFAQa8QlogqzhznKeveaCiDbpk1Bl+aPSMGxiaE2ko=";
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
