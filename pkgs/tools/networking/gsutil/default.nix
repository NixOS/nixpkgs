{stdenv, fetchurl, makeWrapper, python, pycrypto }:

stdenv.mkDerivation rec {
  name = "gsutil-${version}";
  version = "4.6";

  src = fetchurl {
    url = "https://storage.googleapis.com/pub/gsutil.tar.gz";
    sha256 = "1dsd00j7bg27pcxfl4mh0cszkjavzwm64hffqz6ki8amvpj1z0ds";
  };

  buildInputs = [ makeWrapper ];

  phases = "unpackPhase patchPhase checkPhase installPhase fixupPhase distPhase";

  postPatch = ''
    for i in `grep -rl "/usr/bin/env python" .`; do
      substituteInPlace $i --replace "/usr/bin/env python" "${python}/bin/${python.executable}"
    done
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/gsutil
    mkdir -p $out/bin
    makeWrapper $out/share/gsutil/gsutil $out/bin/gsutil --prefix PYTHONPATH : "$PYTHONPATH:${pycrypto}/lib/${python.libPrefix}/site-packages"
  '';

  meta = {
    homepage = https://developers.google.com/storage/docs/gsutil;
    description = "Google Cloud Storage Tool";
    longDescription=''
      gsutil is a Python application that lets you access Google Cloud Storage from the command line.
      You can use gsutil to do a wide range of bucket and object management tasks, including:

      * Creating and deleting buckets.
      * Uploading, downloading, and deleting objects.
      * Listing buckets and objects.
      * Moving, copying, and renaming objects.
      * Editing object and bucket ACLs.
    '';
    maintainers = [ "Russell O'Connor <oconnorr@google.com>" ];
    license = stdenv.lib.licenses.asl20;
  };
}
