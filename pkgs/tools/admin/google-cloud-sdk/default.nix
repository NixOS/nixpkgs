# Make sure that the "with-gce" flag is set when building `google-cloud-sdk`
# for GCE hosts. This flag prevents "google-compute-engine" from being a
# default dependency which is undesirable because this package is
#
#   1) available only on GNU/Linux (requires `systemd` in particular)
#   2) intended only for GCE guests (and is useless elsewhere)
#   3) used by `google-cloud-sdk` only on GCE guests
#

{ stdenv, lib, fetchurl, makeWrapper, python, cffi, cryptography, pyopenssl,
  crcmod, google-compute-engine, with-gce ? false }:

let
  pythonInputs = [ cffi cryptography pyopenssl crcmod ]
                 ++ lib.optional (with-gce) google-compute-engine;
  pythonPath = lib.makeSearchPath python.sitePackages pythonInputs;

  baseUrl = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads";
  sources = name: system: {
    i686-linux = {
      url = "${baseUrl}/${name}-linux-x86.tar.gz";
      sha256 = "127f98a25293d537d5a64d0df559d4053e6a8c77bbdc13566896ff7e6c2ceede";
    };

    x86_64-darwin = {
      url = "${baseUrl}/${name}-darwin-x86_64.tar.gz";
      sha256 = "7b0f037db60b6ebde89afd80ba7c96f036637dd5cba77201952d1137801d5060";
    };

    x86_64-linux = {
      url = "${baseUrl}/${name}-linux-x86_64.tar.gz";
      sha256 = "3cae8a7b021f3c9eaab6c0b59a1301eb7cda3a422e645b3b0c6ccfe89b1e0332";
    };
  }.${system};

in stdenv.mkDerivation rec {
  name = "google-cloud-sdk-${version}";
  version = "182.0.0";

  src = fetchurl (sources name stdenv.system);

  buildInputs = [ python makeWrapper ];

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p "$out"
    tar -xzf "$src" -C "$out" google-cloud-sdk

    mkdir $out/google-cloud-sdk/lib/surface/alpha
    cp ${./alpha__init__.py} $out/google-cloud-sdk/lib/surface/alpha/__init__.py

    mkdir $out/google-cloud-sdk/lib/surface/beta
    cp ${./beta__init__.py} $out/google-cloud-sdk/lib/surface/beta/__init__.py

    # create wrappers with correct env
    for program in gcloud bq gsutil git-credential-gcloud.sh; do
        programPath="$out/google-cloud-sdk/bin/$program"
        binaryPath="$out/bin/$program"
        wrapProgram "$programPath" \
            --set CLOUDSDK_PYTHON "${python}/bin/python" \
            --prefix PYTHONPATH : "${pythonPath}"

        mkdir -p $out/bin
        ln -s $programPath $binaryPath
    done

    # setup bash completion
    mkdir -p "$out/etc/bash_completion.d/"
    mv "$out/google-cloud-sdk/completion.bash.inc" "$out/etc/bash_completion.d/gcloud.inc"

    # This directory contains compiled mac binaries. We used crcmod from
    # nixpkgs instead.
    rm -r $out/google-cloud-sdk/platform/gsutil/third_party/crcmod
  '';

  meta = with stdenv.lib; {
    description = "Tools for the google cloud platform";
    longDescription = "The Google Cloud SDK. This package has the programs: gcloud, gsutil, and bq";
    # This package contains vendored dependencies. All have free licenses.
    license = licenses.free;
    homepage = "https://cloud.google.com/sdk/";
    maintainers = with maintainers; [ stephenmw zimbatm ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
