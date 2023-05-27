{ stdenvNoCC, fetchurl, unzip, lib }:

{ pname, version, zipHash, meta ? {}, passthru ? {}, ... }@args:
let plat = stdenvNoCC.targetPlatform.system; in stdenvNoCC.mkDerivation ({
  inherit pname version;

  src = (fetchurl {
    name = "${pname}-${version}-${plat}.zip";
    hash = if lib.isAttrs zipHash then zipHash.${plat} or (throw "unsupported system") else zipHash;
    url = "https://grafana.com/api/plugins/${pname}/versions/${version}/download" +
    {
      x86_64-linux = "?os=linux&arch=amd64";
      aarch64-linux = "?os=linux&arch=arm64";
      x86_64-darwin = "?os=darwin&arch=amd64";
      aarch64-darwin = "?os=darwin&arch=arm64";
     }.${plat} or (throw "unknown system");
  });

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    cp -R "." "$out"
    chmod -R a-w "$out"
    chmod u+w "$out"
  '';

  passthru = {
    updateScript = [ ./update-grafana-plugin.sh pname ];
  } // passthru;

  meta = {
    homepage = "https://grafana.com/grafana/plugins/${pname}";
  } // meta;
} // (builtins.removeAttrs args [ "zipHash" "pname" "version" "sha256" "meta" ]))
