{stdenv, fetchurl, python27, python27Packages, makeWrapper}:

stdenv.mkDerivation rec {
  version = "0.9.58";
  name = "google-cloud-sdk-${version}";

  src = fetchurl {
    url = "https://dl.google.com/dl/cloudsdk/release/packages/google-cloud-sdk-coretools-linux-static-20150429151447.tar.gz";
    sha256 = "0sak1fmm7z7ry1k2r67a13mpgi55rbnx81s0y0xhd86dm5aw4f48";
  };

  buildInputs = [python27 makeWrapper];

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p "$out"
    tar -xzf "$src" -C "$out" google-cloud-sdk

    # create wrappers with correct env
    for program in gcloud bq gsutil git-credential-gcloud.sh; do
        programPath="$out/google-cloud-sdk/bin/$program"
        wrapper="$out/bin/$program"
        makeWrapper "$programPath" "$wrapper" \
            --set CLOUDSDK_PYTHON "${python27}/bin/python" \
            --prefix PYTHONPATH : "$(toPythonPath ${python27Packages.crcmod})"
    done

    # install man pages
    mv "$out/google-cloud-sdk/help/man" "$out"

    # setup bash completion
    mkdir -p "$out/etc/bash_completion.d/"
    mv "$out/google-cloud-sdk/completion.bash.inc" "$out/etc/bash_completion.d/gcloud.inc"

    # This directory contains compiled mac binaries. We used crcmod from
    # nixpkgs instead.
    rm -r $out/google-cloud-sdk/platform/gsutil/third_party/crcmod
  '';

  meta = {
    description = "Tools for the google cloud platform";
    longDescription = "The Google Cloud SDK. This package has the programs: gcloud, gsutil, and bq";
    version = version;
    # This package contains vendored dependencies. All have free licenses.
    license = stdenv.lib.licenses.free;
    homepage = "https://cloud.google.com/sdk/";
    maintainers = with stdenv.lib.maintainers; [stephenmw];
    platforms = stdenv.lib.platforms.all;
  };
}
