{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "lovelace-xiaomi-vacuum-map-card";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "lovelace-xiaomi-vacuum-map-card";
    tag = "v${version}";
    hash = "sha256-3329L+2Su2XvrKQIKa5btJz3CQWgS+c8qHD/9vxuEbM=";
  };

  npmDepsHash = "sha256-vLxmzqDSmB+6VKjiwG5WH9FUvn0NlVHo9TBmbx5UkG0=";

  # rollup-plugin-typescript2 tries to require tslib/package.json, but the
  # bundled tslib 2.1.0 uses the legacy "./": "./" exports subpath pattern that
  # newer Node no longer honours. Rewrite it to the supported wildcard form.
  preBuild = ''
    substituteInPlace node_modules/rollup-plugin-typescript2/node_modules/tslib/package.json \
      --replace-fail '"./": "./"' '"./*": "./*"'
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/xiaomi-vacuum-map-card.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "xiaomi-vacuum-map-card.js";

  meta = {
    description = "Interactive map card for map-based vacuums in Home Assistant";
    homepage = "https://github.com/PiotrMachowski/lovelace-xiaomi-vacuum-map-card";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
    platforms = lib.platforms.all;
  };
}
