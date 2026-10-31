{
  stdenvNoCC,
  fetchurl,
  unzip,
  lib,
}:
let
  platformKey =
    platform: if platform.go.GOARCH == null then null else "${platform.go.GOOS}-${platform.go.GOARCH}";
in
{
  pname,
  versionPrefix ? "",
  version,
  packages,
  meta ? { },
  passthru ? { },
  ...
}@args:
let
  key = platformKey stdenvNoCC.hostPlatform;
  package =
    if key != null && builtins.hasAttr key packages then
      key
    else if packages ? any then
      "any"
    else
      throw "Unsupported system for ${pname}: ${stdenvNoCC.hostPlatform.system}";
  specificPlatforms = lib.filter (
    system:
    let
      key = platformKey (lib.systems.elaborate system);
    in
    key != null && builtins.hasAttr key packages
  ) lib.platforms.all;
in
stdenvNoCC.mkDerivation (
  {
    inherit pname versionPrefix version;

    src = fetchurl {
      name = "${pname}-${versionPrefix}${version}-${package}.zip";
      inherit (packages.${package}) hash url;
    };

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      cp -R "." "$out"
      chmod -R a-w "$out"
      chmod u+w "$out"
    '';

    passthru = {
      updateScript = [
        ./update-grafana-plugin.sh
        pname
      ];
    }
    // passthru;

    meta = {
      homepage = "https://grafana.com/grafana/plugins/${pname}";
      # `any` may bundle native binaries rather than being platform-independent.
      # Keep it available as a best-effort fallback on other Unix platforms.
      platforms = lib.unique (specificPlatforms ++ lib.optionals (packages ? any) lib.platforms.unix);
    }
    // meta;
  }
  // (removeAttrs args [
    "packages"
    "pname"
    "versionPrefix"
    "version"
    "sha256"
    "meta"
  ])
)
