{ stdenv, autoPatchelfHook, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "confluent-cli";
  version = "3.37.0";

  # To get the latest version:
  # curl -L https://cnfl.io/cli | sh -s -- -l | grep -v latest | sort -V | tail -n1
  src = fetchurl (if stdenv.hostPlatform.isDarwin then {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/${version}/confluent_${version}_darwin_amd64.tar.gz";
      sha256 = "804401c4286c339097151b1605555c43cf3143637896a908c477d928f10c94e6";
    } else {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/${version}/confluent_${version}_linux_amd64.tar.gz";
      sha256 = "bc907fd2875503ce9f66d461fc283928f0fcabc0901443654738e9238d5439cf";
    });

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontStrip = stdenv.isDarwin;

  installPhase = ''
    mkdir -p $out/{bin,share/doc/confluent-cli}
    cp confluent $out/bin/
    cp LICENSE $out/share/doc/confluent-cli/
    cp -r legal $out/share/doc/confluent-cli/
  '';

  meta = with lib; {
    description = "Confluent CLI";
    homepage = "https://docs.confluent.io/confluent-cli/current/overview.html";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ rguevara84 ];

    # TODO: There's support for i686 systems but I do not have any such system
    # to build it locally on, it's also unfree so I cannot rely on ofborg to
    # build it. Get the list of supported system by looking at the list of
    # files in the S3 bucket:
    #
    #   https://s3-us-west-2.amazonaws.com/confluent.cloud?prefix=confluent-cli/archives/1.25.0/&delimiter=/%27
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
