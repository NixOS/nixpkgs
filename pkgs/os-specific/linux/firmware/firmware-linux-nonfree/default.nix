{ stdenv, fetchgit, runCommand, git, cacert, gnupg }:

stdenv.mkDerivation rec {
  name = "firmware-linux-nonfree-${version}";
  version = "2017-10-13-${src.iwlRev}";

  # The src runCommand automates the process of building a merged repository of both
  #
  # https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/
  # https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git/
  #
  # This gives us up to date iwlwifi firmware as well as
  # the usual set of firmware. firmware/linux-firmware usually lags kernel releases
  # so iwlwifi cards will fail to load on newly released kernels.
  #
  # To update, go to the above repositories and look for latest tags / commits, then
  # update version to the more recent commit date

  src = runCommand "firmware-linux-nonfree-src-merged-${version}" {
    shallowSince = "2017-10-01";
    baseRev = "85313b4aa4ef0c2ce41bbd0ffdb9b03363256f28";
    iwlRev = "iwlwifi-fw-2017-11-15";

    # When updating this, you need to let it run with a wrong hash, in order to find out the desired hash
    # randomly mutate the hash to break out of fixed hash, when updating
    outputHash = "0kpg1xmx5mjnqxv5n21yvvq4sl59yjpwjv9ficd054544q1v2jly";

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";

    # Doing the download on a remote machine just duplicates network
    # traffic, so don't do that.
    preferLocalBuild = true;

    buildInputs = [ git gnupg ];
    NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  } ''
    git init src && (
      cd src
      git config user.email "build-daemon@nixos.org"
      git config user.name "Nixos Build Daemon $name"
      git remote add base https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
      git remote add iwl https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git
      git fetch --shallow-since=$shallowSince base
      git fetch --shallow-since=$shallowSince iwl
      git checkout -b work $baseRev
      git merge $iwlRev)
    rm -rf src/.git
    cp -a src $out
  '';

  preInstall = ''
    mkdir -p $out
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = http://packages.debian.org/sid/firmware-linux-nonfree;
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = { inherit version; };
}
