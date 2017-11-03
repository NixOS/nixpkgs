{ stdenv, lib, fetchurl, python, cffi, cryptography, pyopenssl, crcmod, google-compute-engine, makeWrapper }:

# other systems not supported yet
let
  pythonInputs = [ cffi cryptography pyopenssl crcmod google-compute-engine ];
  pythonPath = lib.makeSearchPath python.sitePackages pythonInputs;

  sources = name: system: {
    i686-linux = {
      url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${name}-linux-x86.tar.gz";
      sha256 = "0aq938s1w9mzj60avmcc68kgll54pl7635vl2mi89f6r56n0xslp";
    };

    x86_64-darwin = {
      url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${name}-darwin-x86_64.tar.gz";
      sha256 = "13k2i1svry9q800s1jgf8jss0rzfxwk6qci3hsy1wrb9b2mwlz5g";
    };

    x86_64-linux = {
      url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${name}-linux-x86_64.tar.gz";
      sha256 = "1kvaz8p1iflsi85wwi7lb6km6frj70xsricyz1ah0sw3q71zyqmc";
    };
  }.${system};

in stdenv.mkDerivation rec {
  name = "google-cloud-sdk-${version}";
  version = "177.0.0";

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
