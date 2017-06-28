{stdenv, fetchurl, python27, python27Packages, makeWrapper}:

with python27Packages;

# other systems not supported yet
assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin";

stdenv.mkDerivation rec {
  name = "google-cloud-sdk-${version}";
  version = "159.0.0";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${name}-linux-x86.tar.gz";
        sha256 = "12mksd9fj1106zj6k2knlfc3knzm5kkf0s85l5l9zr6f7n0jabpd";
      }
    else if stdenv.system == "x86_64-darwin" then
      fetchurl {
        url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${name}-darwin-x86_64.tar.gz";
        sha256 = "160zdf7rr2f43qv12yr9c682kk0dh3rlcdqzb2ahpqpajqmcz4qw";
      }
    else
      fetchurl {
        url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${name}-linux-x86_64.tar.gz";
        sha256 = "0ai2rvk47gsb96k80w6wim04cjxyj5lhrg8kv6dgj53m81sqah2v";
      };

  buildInputs = [python27 makeWrapper];

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p "$out"
    tar -xzf "$src" -C "$out" google-cloud-sdk

    # create wrappers with correct env
    for program in gcloud bq gsutil git-credential-gcloud.sh; do
        programPath="$out/google-cloud-sdk/bin/$program"
        binaryPath="$out/bin/$program"
        wrapProgram "$programPath" \
            --set CLOUDSDK_PYTHON "${python27}/bin/python" \
            --prefix PYTHONPATH : "$(toPythonPath ${cffi}):$(toPythonPath ${cryptography}):$(toPythonPath ${pyopenssl}):$(toPythonPath ${crcmod})"

        mkdir -p $out/bin
        ln -s $programPath $binaryPath
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

  meta = with stdenv.lib; {
    description = "Tools for the google cloud platform";
    longDescription = "The Google Cloud SDK. This package has the programs: gcloud, gsutil, and bq";
    version = version;
    # This package contains vendored dependencies. All have free licenses.
    license = licenses.free;
    homepage = "https://cloud.google.com/sdk/";
    maintainers = with maintainers; [stephenmw zimbatm];
    platforms = with platforms; linux ++ darwin;
  };
}
