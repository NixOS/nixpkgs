{ stdenv, fetchgit, runCommand, git, cacert, gnupg }:

stdenv.mkDerivation rec {
  name = "firmware-linux-nonfree-${version}";
  version = "2018-01-04-${src.iwlRev}";

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
    baseRev = "65b1c68c63f974d72610db38dfae49861117cae2";
    iwlRev = "iwlwifi-fw-2017-11-15";

    # When updating this, you need to let it run with a wrong hash, in order to find out the desired hash
    # randomly mutate the hash to break out of fixed hash, when updating
    outputHash = "1anr7fblxfcrfrrgq98kzy64yrwygc2wdgi47skdmjxhi3wbrvxz";

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";

    # Doing the download on a remote machine just duplicates network
    # traffic, so don't do that.
    preferLocalBuild = true;

    nativeBuildInputs = [ cacert git gnupg ];
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

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  meta = with stdenv.lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = http://packages.debian.org/sid/firmware-linux-nonfree;
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = { inherit version; };
}
