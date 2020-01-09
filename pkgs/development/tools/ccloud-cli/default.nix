{ stdenv, autoPatchelfHook, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "ccloud-cli";
  version = "0.202.0";

  # To get the latest version:
  # curl -L 'https://s3-us-west-2.amazonaws.com/confluent.cloud?prefix=ccloud-cli/archives/&delimiter=/' | nix run nixpkgs.libxml2 -c xmllint --format -
  src = fetchurl (if stdenv.hostPlatform.isDarwin then {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/ccloud-cli/archives/${version}/ccloud_v${version}_darwin_amd64.tar.gz";
      sha256 = "1w7c7fwpjj6f26nmcgm6rkrl4v9zhdpygkh02la77n23lg8wxah5";
    } else {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/ccloud-cli/archives/${version}/ccloud_v${version}_linux_amd64.tar.gz";
      sha256 = "1xbhv2viw8cbwv03rfq99jddnw5lwy812a8xby348290l323xi89";
    });

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    mkdir -p $out/{bin,share/doc/ccloud-cli}
    cp ccloud $out/bin/
    cp LICENSE $out/share/doc/ccloud-cli/
    cp -r legal $out/share/doc/ccloud-cli/
  '';

  meta = with lib; {
    description = "Confluent Cloud CLI";
    homepage = https://docs.confluent.io/current/cloud/cli/index.html;
    license = licenses.unfree;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
