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
<<<<<<< HEAD
  version = "0.48.0";
=======
  version = "0.46.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "terraform-linters";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QU3nSq13klBoa3+czvdlrNwtG0iQqoC/hcbTHr5KN14=";
  };

  vendorHash = "sha256-yWxBiOPB0z3+bd6f+LalfVYYoV04scnl3YXJkaTo/dk=";
=======
    hash = "sha256-oMf1uUD+7z42Z6bfMxNCWNFu/WwdEqBocVbbfe2OPbo=";
  };

  vendorHash = "sha256-1S3my0/77LiiGZDemVrYzN1jMcZdTyd404y67euraeI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    homepage = "https://github.com/terraform-linters/tflint";
<<<<<<< HEAD
    changelog = "https://github.com/terraform-linters/tflint/blob/v${version}/CHANGELOG.md";
=======
    changelog = "https://github.com/terraform-linters/tflint/raw/v${version}/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
