{ lib, buildRubyGem, ruby, writeScript, testers, bundler }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.5.9";
  source.sha256 = "sha256-4rYTJb41m85U6w/tiEBO/mfl4fgAPTSiIYQeO3Za7AY=";
  dontPatchShebangs = true;

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';

  passthru = {
    updateScript = writeScript "gem-update-script" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl common-updater-scripts jq

      set -eu -o pipefail

      latest_version=$(curl -s https://rubygems.org/api/v1/gems/${gemName}.json | jq --raw-output .version)
      update-source-version ${gemName} "$latest_version"
    '';
    tests.version = testers.testVersion {
      package = bundler;
      command = "bundler -v";
      version = version;
    };
  };

  meta = with lib; {
    description = "Manage your Ruby application's gem dependencies";
    homepage = "https://bundler.io";
    changelog = "https://github.com/rubygems/rubygems/blob/bundler-v${version}/bundler/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ anthonyroussel ];
    mainProgram = "bundler";
  };
}
