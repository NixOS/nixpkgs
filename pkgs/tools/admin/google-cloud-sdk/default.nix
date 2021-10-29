# Make sure that the "with-gce" flag is set when building `google-cloud-sdk`
# for GCE hosts. This flag prevents "google-compute-engine" from being a
# default dependency which is undesirable because this package is
#
#   1) available only on GNU/Linux (requires `systemd` in particular)
#   2) intended only for GCE guests (and is useless elsewhere)
#   3) used by `google-cloud-sdk` only on GCE guests
#

{ stdenv, lib, fetchurl, makeWrapper, nixosTests, python, openssl, jq, with-gce ? false }:

let
  pythonEnv = python.withPackages (p: with p; [
    cffi
    cryptography
    openssl
    crcmod
  ] ++ lib.optional (with-gce) google-compute-engine);

  baseUrl = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads";
  sources = name: system: {
    x86_64-darwin = {
      url = "${baseUrl}/${name}-darwin-x86_64.tar.gz";
      sha256 = "19s3nryngzv7zs7piwx92hii5p2y97fs7wngqrd9v8cxvgavp1dc";
    };

    aarch64-darwin = {
      url = "${baseUrl}/${name}-darwin-arm.tar.gz";
      sha256 = "1iphpkxrrp0gdan7ikbjbhykdpazcs1fnlcwkfyv2m9baggkd53z";
    };

    x86_64-linux = {
      url = "${baseUrl}/${name}-linux-x86_64.tar.gz";
      sha256 = "1z1ymvij9vi8jc05b004jhd08dqbk133wd03fdxnagd6nfr0bjqm";
    };

    i686-linux = {
      url = "${baseUrl}/${name}-linux-x86.tar.gz";
      sha256 = "17i5pkwjmi38klgr12xqgza7iwkx459cbavlq0x33zaq2a4zanlc";
    };

    aarch64-linux = {
      url = "${baseUrl}/${name}-linux-arm.tar.gz";
      sha256 = "17zjnab4ai5w6p3cbxys9zsg4bdlp0lh6pvmkvdz9hszxxch4yms";
    };
  }.${system} or (throw "Unsupported system: ${system}");

in stdenv.mkDerivation rec {
  pname = "google-cloud-sdk";
  version = "362.0.0";

  src = fetchurl (sources "${pname}-${version}" stdenv.hostPlatform.system);

  buildInputs = [ python ];

  nativeBuildInputs = [ jq makeWrapper ];

  patches = [
    # For kubectl configs, don't store the absolute path of the `gcloud` binary as it can be garbage-collected
    ./gcloud-path.patch
    # Disable checking for updates for the package
    ./gsutil-disable-updates.patch
    # Try to use cloud_sql_proxy from SDK only if it actually exists, otherwise, search for one in PATH
    ./cloud_sql_proxy_path.patch
  ];

  installPhase = ''
    runHook preInstall

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
    mkdir -p $out/share/bash-completion/completions
    mv $out/google-cloud-sdk/completion.bash.inc $out/share/bash-completion/completions/gcloud
    ln -s $out/share/bash-completion/completions/gcloud $out/share/bash-completion/completions/gsutil

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

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) google-cloud-sdk; };
  };

  meta = with lib; {
    description = "Tools for the google cloud platform";
    longDescription = "The Google Cloud SDK. This package has the programs: gcloud, gsutil, and bq";
    # This package contains vendored dependencies. All have free licenses.
    license = licenses.free;
    homepage = "https://cloud.google.com/sdk/";
    maintainers = with maintainers; [ iammrinal0 pradyuman stephenmw zimbatm ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    mainProgram = "gcloud";
  };
}
