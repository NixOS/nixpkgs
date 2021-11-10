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
      sha256 = "0p2jpzkd0mn70wvs5m6xh9v1f5wfxww6miz2xgd50wa71kh5q9hl";
    };

    aarch64-darwin = {
      url = "${baseUrl}/${name}-darwin-arm.tar.gz";
      sha256 = "0lp5l79dm263ymm32abkz7hnfb9zwhwi9xspr2gx8h4jgpw4hmxm";
    };

    x86_64-linux = {
      url = "${baseUrl}/${name}-linux-x86_64.tar.gz";
      sha256 = "0i9h61qsd0pmvypjkmp8nzgrdr3n6wdvmizrsnm9azrsmsqbx4cl";
    };

    i686-linux = {
      url = "${baseUrl}/${name}-linux-x86.tar.gz";
      sha256 = "1cfh5bx7zcjbjqbsin4aqd10jlaibbckgjpp16lh4aywrysdfdzh";
    };

    aarch64-linux = {
      url = "${baseUrl}/${name}-linux-arm.tar.gz";
      sha256 = "0v8hrymq0iwrw936v7bll012gi20zrhjn4jjgn940y5rrdz7pk2i";
    };
  }.${system} or (throw "Unsupported system: ${system}");

in stdenv.mkDerivation rec {
  pname = "google-cloud-sdk";
  version = "364.0.0";

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

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/gcloud version --format json | jq '."Google Cloud SDK"' | grep "${version}"
  '';

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
