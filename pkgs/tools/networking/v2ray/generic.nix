{ lib, linkFarm, buildGoModule, runCommand, makeWrapper

# Version specific args
, version, src, assets
, ... }:

let
  assetsDrv = linkFarm "v2ray-assets" (lib.mapAttrsToList (name: path: {
    inherit name path;
  }) assets);

  core = buildGoModule rec {
    pname = "v2ray-core";
    inherit version src;

  vendorSha256 = "1lh8382gyss01frq4gxyx9p26p5m8f158qfw55sy5wb7ddrafcc2";

    buildPhase = ''
      runHook preBuild

      go build -o v2ray v2ray.com/core/main
      go build -o v2ctl v2ray.com/core/infra/control/main

      runHook postBuild
    '';

    installPhase = ''
      install -Dm755 v2ray v2ctl -t $out/bin
    '';
  };

in runCommand "v2ray-${version}" {
  inherit version;

  buildInputs = [ assetsDrv core ];
  nativeBuildInputs = [ makeWrapper ];

  meta = {
    homepage = "https://www.v2ray.com/en/index.html";
    description = "A platform for building proxies to bypass network restrictions";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ servalcatty ];
  };

} ''
  for file in ${core}/bin/*; do
    makeWrapper "$file" "$out/bin/$(basename "$file")" \
      --set-default V2RAY_LOCATION_ASSET ${assetsDrv}
  done
''