# Make sure that the "with-gce" flag is set when building `google-cloud-sdk`
# for GCE hosts. This flag prevents "google-compute-engine" from being a
# default dependency which is undesirable because this package is
#
#   1) available only on GNU/Linux (requires `systemd` in particular)
#   2) intended only for GCE guests (and is useless elsewhere)
#   3) used by `google-cloud-sdk` only on GCE guests
#

{ stdenv, lib, fetchurl, makeWrapper, python, openssl, jq, with-gce ? false }:

let
  pythonEnv = python.withPackages (p: with p; [
    cffi
    cryptography
    pyopenssl
    crcmod
  ] ++ lib.optional (with-gce) google-compute-engine);

  baseUrl = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads";
  sources = name: system: {
    x86_64-darwin = {
      url = "${baseUrl}/${name}-darwin-x86_64.tar.gz";
      sha256 = "0hg4823dlnf9ahqh9dr05wsi6cdxn9mbwhg65jng3d2aws3ski6r";
    };

    x86_64-linux = {
      url = "${baseUrl}/${name}-linux-x86_64.tar.gz";
      sha256 = "00ziqr60q1la716c9cy3hjpyq3hiw3m75d4wry6prn5655jw4ph6";
    };
  }.${system};

  strip = if stdenv.isDarwin then "strip -x" else "strip";

in stdenv.mkDerivation rec {
  pname = "google-cloud-sdk";
  version = "281.0.0";

  src = fetchurl (sources "${pname}-${version}" stdenv.hostPlatform.system);

  buildInputs = [ python makeWrapper ];

  nativeBuildInputs = [ jq ];

  patches = [
    ./gcloud-path.patch
    ./gsutil-disable-updates.patch
  ];

  installPhase = ''
    mkdir -p $out/google-cloud-sdk
    cp -R * .install $out/google-cloud-sdk/

    mkdir -p $out/google-cloud-sdk/lib/surface/{alpha,beta}
    cp ${./alpha__init__.py} $out/google-cloud-sdk/lib/surface/alpha/__init__.py
    cp ${./beta__init__.py} $out/google-cloud-sdk/lib/surface/beta/__init__.py

    # create wrappers with correct env
    for program in gcloud bq gsutil git-credential-gcloud.sh docker-credential-gcloud; do
        programPath="$out/google-cloud-sdk/bin/$program"
        binaryPath="$out/bin/$program"
        wrapProgram "$programPath" \
            --set CLOUDSDK_PYTHON "${pythonEnv}/bin/python" \
            --prefix PYTHONPATH : "${pythonEnv}/${python.sitePackages}" \
            --prefix PATH : "${openssl.bin}/bin"

        mkdir -p $out/bin
        ln -s $programPath $binaryPath
    done

    # disable component updater and update check
    substituteInPlace $out/google-cloud-sdk/lib/googlecloudsdk/core/config.json \
      --replace "\"disable_updater\": false" "\"disable_updater\": true"
    echo "
    [component_manager]
    disable_update_check = true" >> $out/google-cloud-sdk/properties

    # setup bash completion
    mkdir -p $out/etc/bash_completion.d
    mv $out/google-cloud-sdk/completion.bash.inc $out/etc/bash_completion.d/gcloud.inc

    # This directory contains compiled mac binaries. We used crcmod from
    # nixpkgs instead.
    rm -r $out/google-cloud-sdk/platform/gsutil/third_party/crcmod \
          $out/google-cloud-sdk/platform/gsutil/third_party/crcmod_osx

    # remove tests and test data
    find $out -name tests -type d -exec rm -rf '{}' +
    rm $out/google-cloud-sdk/platform/gsutil/gslib/commands/test.py

    # compact all the JSON
    find $out -name \*.json | while read path; do
      jq -c . $path > $path.min
      mv $path.min $path
    done

    # strip the Cython gRPC library
    ${strip} $out/google-cloud-sdk/lib/third_party/grpc/_cython/cygrpc.so
  '';

  meta = with stdenv.lib; {
    description = "Tools for the google cloud platform";
    longDescription = "The Google Cloud SDK. This package has the programs: gcloud, gsutil, and bq";
    # This package contains vendored dependencies. All have free licenses.
    license = licenses.free;
    homepage = "https://cloud.google.com/sdk/";
    maintainers = with maintainers; [ pradyuman stephenmw zimbatm ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
