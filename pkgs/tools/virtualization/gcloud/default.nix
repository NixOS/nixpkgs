{ stdenv, fetchurl, python, jre, which }:

stdenv.mkDerivation {

  name = "gcloud";
  src = fetchurl {
    url = "https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz";
    sha256 = "cc649eb16195c73c2668a73931e46635dd02fc24090cf137a20806b11911c705";
  };

  buildInputs = [ python jre which ];

  installPhase = 
    ''
      export HOME=$out
      python bin/bootstrapping/install.py --usage-reporting false --disable-installation-options --path-update false --bash-completion false
      cp -r bin $out/bin
      cp -r lib $out/lib
    '';

  meta = {
    homepage = https://cloud.google.com/sdk/;
    description = "oogle Cloud SDK contains tools and libraries that enable you to easily create and manage resources on Google Cloud Platform, including App Engine, Compute Engine, Cloud Storage, BigQuery, Cloud SQL, and Cloud DNS.";
    license = stdenv.lib.licenses.asl20;
  };
}

