{ stdenv, fetchgit, runCommand, git, cacert, gnupg }:

stdenv.mkDerivation rec {
  name = "firmware-linux-nonfree-${version}";
  version = "2017-10-09-${src.iwlRev}";

  # The src runCommand automates the process of building a merged repository of both
  #
  # http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/
  # http://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git/
  #
  # This gives us up to date iwlwifi firmware as well as
  # the usual set of firmware. firmware/linux-firmware usually lags kernel releases
  # so iwlwifi cards will fail to load on newly released kernels.
  #
  # To update, go to the above repositories and look for latest tags / commits, then
  # update version to the more recent commit date

  src = runCommand "firmware-linux-nonfree-src-merged-${version}" {
    # When updating this, you need to let it run with a wrong hash, in order to find out the desired hash
    baseRev = "bf04291309d3169c0ad3b8db52564235bbd08e30";
    iwlRev = "iwlwifi-fw-2017-11-03";

    # randomly mutate the hash to break out of fixed hash, when updating
    outputHash = "11izv1vpq9ixlqdss19lzs5q289d7jxr5kgf6iymk4alxznffd8z";

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    buildInputs = [ git gnupg ];
    NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  } ''
    git init src && (
      cd src
      git config user.email "build-daemon@nixos.org"
      git config user.name "Nixos Build Daemon $name"
      git remote add base git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
      git remote add iwl git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git
      git fetch base $baseRev
      git checkout -b work FETCH_HEAD
      git fetch iwl $iwlRev
      git merge FETCH_HEAD)
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
