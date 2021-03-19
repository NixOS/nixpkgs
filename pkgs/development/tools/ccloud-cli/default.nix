{ stdenv, autoPatchelfHook, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "ccloud-cli";
  version = "1.25.0";

  # To get the latest version:
  # curl -L 'https://s3-us-west-2.amazonaws.com/confluent.cloud?prefix=ccloud-cli/archives/&delimiter=/' | nix run nixpkgs.libxml2 -c xmllint --format -
  src = fetchurl (if stdenv.hostPlatform.isDarwin then {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/ccloud-cli/archives/${version}/ccloud_v${version}_darwin_amd64.tar.gz";
      sha256 = "0306jg36dpccwyy239r2xvw3bvsrnrdc88390g26fhcb0048qmgb";
    } else {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/ccloud-cli/archives/${version}/ccloud_v${version}_linux_amd64.tar.gz";
      sha256 = "02sly7cxqlrfd6chamlp05k9ar93mpfrkx5183js0hf595nlki61";
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
    homepage = "https://docs.confluent.io/current/cloud/cli/index.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
