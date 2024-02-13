{ stdenvNoCC, fetchurl, unzip, lib }:

{ pname, version, zipHash, meta ? {}, passthru ? {}, ... }@args:
let plat = stdenvNoCC.hostPlatform.system; in stdenvNoCC.mkDerivation ({
  inherit pname version;

  src = if lib.isAttrs zipHash then
    fetchurl {
      name = "${pname}-${version}-${plat}.zip";
      sha256 = zipHash.${plat} or (throw "unsupported system");
      url = "https://grafana.com/api/plugins/${pname}/versions/${version}/download" + {
        x86_64-linux = "?os=linux&arch=amd64";
        aarch64-linux = "?os=linux&arch=arm64";
        x86_64-darwin = "?os=darwin&arch=amd64";
        aarch64-darwin = "?os=darwin&arch=arm64";
      }.${plat} or (throw "unknown system");
    }
  else
    fetchurl {
      name = "${pname}-${version}.zip";
      sha256 = zipHash;
      url = "https://grafana.com/api/plugins/${pname}/versions/${version}/download";
    }
  ;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    cp -R "." "$out"
    chmod -R a-w "$out"
    chmod u+w "$out"
  '';

  passthru = {
    updateScript = ./update-grafana-plugins.sh;
  } // passthru;

  meta = with lib; {
    homepage = "https://grafana.com/grafana/plugins/${pname}";
    license = licenses.asl20;
    platforms = if isAttrs zipHash then attrNames zipHash else platforms.unix;
  } // meta;
} // (builtins.removeAttrs args [ "zipHash" "pname" "version" "sha256" "meta" ]))
