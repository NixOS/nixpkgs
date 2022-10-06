{ lib, buildRubyGem, ruby, writeScript }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "2.3.23";
  source.sha256 = "sha256-xYrUhtzNfN3X9r8GqGj9d1aeZkcPozFrk/2c9oVkKx8=";
  dontPatchShebangs = true;

  passthru.updateScript = writeScript "gem-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts jq

    set -eu -o pipefail

    latest_version=$(curl -s https://rubygems.org/api/v1/gems/${gemName}.json | jq --raw-output .version)
    update-source-version ${gemName} "$latest_version"
  '';

  postFixup = ''
    sed -i -e "s/activate_bin_path/bin_path/g" $out/bin/bundle
  '';

  meta = with lib; {
    description = "Manage your Ruby application's gem dependencies";
    homepage = "https://bundler.io";
    license = licenses.mit;
    maintainers = with maintainers; [anthonyroussel];
  };
}
