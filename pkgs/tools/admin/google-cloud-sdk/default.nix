{stdenv, fetchurl, python27, python27Packages, makeWrapper}:

with python27Packages;

# other systems not supported yet
assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin";

stdenv.mkDerivation rec {
  name = "google-cloud-sdk-${version}";
  version = "160.0.0";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${name}-linux-x86.tar.gz";
        sha256 = "0lidnjcgpnyv6f8gjy44zr7kmgcr53c85zax0rdypqs6sx3sly2v";
      }
    else if stdenv.system == "x86_64-darwin" then
      fetchurl {
        url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${name}-darwin-x86_64.tar.gz";
        sha256 = "1v4j89pycndjq9ap3rig1s5njd6qp01d0fsgr8xl3vpipsrj93c0";
      }
    else
      fetchurl {
        url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${name}-linux-x86_64.tar.gz";
        sha256 = "1558qxzvqxvv13lm6adrfcd7m3p21c4rw6hqqavz4xgf6nybz6g7";
      };


  buildInputs = [python27 makeWrapper];

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
