{ stdenv, autoPatchelfHook, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "ccloud-cli";
  version = "1.39.0";

  # To get the latest version:
  # curl -L https://cnfl.io/ccloud-cli | sh -s -- -l | grep -v latest | sort -V | tail -n1
  src = fetchurl (if stdenv.hostPlatform.isDarwin then {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/ccloud-cli/archives/${version}/ccloud_v${version}_darwin_amd64.tar.gz";
      sha256 = "0jqpmnx3izl4gv02zpx03z6ayi3cb5if4rnyl1374yaclx44k1gd";
    } else {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/ccloud-cli/archives/${version}/ccloud_v${version}_linux_amd64.tar.gz";
      sha256 = "0936hipcl37w4mzzsnjlz4q1z4j9094i4irigzqwg14gdbs7p11s";
    });

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontStrip = stdenv.isDarwin;

  installPhase = ''
    mkdir -p $out/{bin,share/doc/ccloud-cli}
    cp ccloud $out/bin/
    cp LICENSE $out/share/doc/ccloud-cli/
    cp -r legal $out/share/doc/ccloud-cli/
  '';

  meta = with lib; {
    description = "Confluent Cloud CLI";
    homepage = "https://docs.confluent.io/current/cloud/cli/index.html";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
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
