{ stdenv, autoPatchelfHook, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "ccloud-cli";
  version = "1.25.0";

  # To get the latest version:
  # curl -L https://cnfl.io/ccloud-cli | sh -s -- -l | grep -v latest | sort -V | tail -n1
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

    # TODO: There's support for i686 systems but I do not have any such system
    # to build it locally on, it's also unfree so I cannot rely on ofborg to
    # build it. Get the list of supported system by looking at the list of
    # files in the S3 bucket:
    #
    #   https://s3-us-west-2.amazonaws.com/confluent.cloud?prefix=ccloud-cli/archives/1.25.0/&delimiter=/%27
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
