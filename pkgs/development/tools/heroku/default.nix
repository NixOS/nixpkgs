{ stdenv, lib, fetchzip, makeWrapper, nodejs, writeScript }:

stdenv.mkDerivation {
  pname = "heroku";
  version = "8.11.4";

  src = fetchzip {
    url = "https://cli-assets.heroku.com/versions/8.11.4/501330b/heroku-v8.11.4-501330b-linux-x64.tar.xz";
    hash = "sha256-Q8kXXsk2VGNLv4LyUqnN3Rapozac/jgkyhSnkBOcDmo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/heroku $out/bin
    cp -pr * $out/share/heroku
    substituteInPlace $out/share/heroku/bin/run \
      --replace "/usr/bin/env node" "${nodejs}/bin/node"
    makeWrapper $out/share/heroku/bin/run $out/bin/heroku \
      --set HEROKU_DISABLE_AUTOUPDATE 1
  '';

  passthru.updateScript = writeScript "update-heroku" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -I nixpkgs=./. -i bash -p nix-prefetch curl jq common-updater-scripts
    resp="$(
        curl -L "https://cli-assets.heroku.com/versions/heroku-linux-x64-tar-xz.json" \
            | jq '[to_entries[] | { version: .key, url: .value } | select(.version|contains("-")|not)] | sort_by(.version|split(".")|map(tonumber)) | .[-1]'
    )"
    url="$(jq <<<"$resp" .url --raw-output)"
    version="$(jq <<<"$resp" .version --raw-output)"
    hash="$(nix-prefetch fetchzip --url "$(jq <<<"$resp" .url --raw-output)")"
    update-source-version heroku "$version" "$hash" "$url"
  '';

  meta = {
    homepage = "https://devcenter.heroku.com/articles/heroku-cli";
    description = "Everything you need to get started using Heroku";
    mainProgram = "heroku";
    maintainers = with lib.maintainers; [ aflatter mirdhyn ];
    license = lib.licenses.mit;
    platforms = with lib.platforms; unix;
  };
}
