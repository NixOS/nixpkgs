{ stdenv, fetchurl, python, jdk, which }:

stdenv.mkDerivation {

  name = "google-cloud-sdk";
  src = fetchurl {
    url = "https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz";
    sha256 = "1f4237a2e52b813fefd905e5a748276186e03de0f28b94532d749fcf68a2ae10";
  };

  buildInputs = [ python jdk which ];

  preConfigure =
    ''
      # google-cloud-sdk writes some things to $HOME during installation.
      export HOME=$(pwd)/fake-home
      mkdir -p $HOME
      mkdir $out
    '';

  installPhase =
    ''
      python bin/bootstrapping/install.py --usage-reporting false --disable-installation-options --path-update false --bash-completion false
      ls -al
      cp -r ./* $out
    '';

  meta = {
    homepage = https://cloud.google.com/sdk/;
    description = "Tools and development libraries for managing Google Cloud Platform resources.";
    license = stdenv.lib.licenses.asl20;
  };
}
