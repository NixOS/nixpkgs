{ stdenvNoCC, fetchurl, unzip }:

{ pname, version, zipHash, meta ? {}, passthru ? {}, ... }@args:
stdenvNoCC.mkDerivation ({
  inherit pname version;

  src = fetchurl {
    name = "${pname}-${version}.zip";
    url = "https://grafana.com/api/plugins/${pname}/versions/${version}/download";
    hash = zipHash;
  };

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
} // (builtins.removeAttrs args [ "pname" "version" "sha256" "meta" ]))
