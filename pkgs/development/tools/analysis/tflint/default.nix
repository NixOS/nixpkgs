{ lib
, buildGoModule
, fetchFromGitHub
, runCommand
, makeWrapper
, tflint
, tflint-plugins
, symlinkJoin
}:

buildGoModule rec {
  pname = "tflint";
  version = "0.50.3";

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PfPynSPuMhiyQW9f6HY2WDNlmtltU4xOo0A88I/bCuI=";
  };

  vendorHash = "sha256-HjvEbEfPVeqAVmVKCJHYPSZjZc19DV1HDaz/HcBJAUg=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  passthru.withPlugins = plugins:
    let
      actualPlugins = plugins tflint-plugins;
      pluginDir = symlinkJoin {
        name = "tflint-plugin-dir";
        paths = [ actualPlugins ];
      };
    in
    runCommand "tflint-with-plugins"
      {
        nativeBuildInputs = [ makeWrapper ];
      } ''
      makeWrapper ${tflint}/bin/tflint $out/bin/tflint \
        --set TFLINT_PLUGIN_DIR "${pluginDir}"
    '';

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    mainProgram = "tflint";
    homepage = "https://github.com/terraform-linters/tflint";
    changelog = "https://github.com/terraform-linters/tflint/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
