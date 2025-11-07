{
  stdenvNoCC,
  fetchurl,
  unzip,
  lib,
}:

{
  pname,
  versionPrefix ? "",
  version,
  zipHash,
  meta ? { },
  passthru ? { },
  ...
}@args:
let
  plat = stdenvNoCC.hostPlatform.system;
in
stdenvNoCC.mkDerivation (
  {
    inherit pname versionPrefix version;

    src =
      if lib.isAttrs zipHash then
        fetchurl {
          name = "${pname}-${versionPrefix}${version}-${plat}.zip";
          hash = zipHash.${plat} or (throw "Unsupported system: ${plat}");
          url =
            "https://grafana.com/api/plugins/${pname}/versions/${versionPrefix}${version}/download"
            + {
              x86_64-linux = "?os=linux&arch=amd64";
              aarch64-linux = "?os=linux&arch=arm64";
              x86_64-darwin = "?os=darwin&arch=amd64";
              aarch64-darwin = "?os=darwin&arch=arm64";
            }
            .${plat} or (throw "Unsupported system: ${plat}");
        }
      else
        fetchurl {
          name = "${pname}-${versionPrefix}${version}.zip";
          hash = zipHash;
          url = "https://grafana.com/api/plugins/${pname}/versions/${versionPrefix}${version}/download";
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
    }
    // meta;
  }
  // (removeAttrs args [
    "zipHash"
    "pname"
    "versionPrefix"
    "version"
    "sha256"
    "meta"
  ])
)
