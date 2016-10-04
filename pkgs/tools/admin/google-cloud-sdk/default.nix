{stdenv, fetchurl, python27, python27Packages, makeWrapper}:

with python27Packages;

stdenv.mkDerivation rec {
  name = "google-cloud-sdk-${version}";
  version = "122.0.0";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${name}-linux-x86.tar.gz";
        sha256 = "0nx348yx1avbb34bpj316fb7jzyzkylscyx8kv183rg4s1q2f798";
      }
    else
      fetchurl {
        url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${name}-linux-x86_64.tar.gz";
        sha256 = "0jhw8yv2kv0fs64rzvddx3szzpn74nqnd3rbd9wx2vi6nmffkrwv";
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
            --prefix PYTHONPATH : "$(toPythonPath ${cffi}):$(toPythonPath ${cryptography}):$(toPythonPath ${pyopenssl}):$(toPythonPath ${crcmod})"
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
    platforms = platforms.linux;
  };
}
