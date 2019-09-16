{ stdenv
, fetchgit
, fetchpatch
, autoreconfHook
, pkgconfig
, ell
, coreutils
, readline
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "iwd";
  version = "0.20";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = version;
    sha256 = "03ca47d4hn28vkf5fr6ck1gz5py4lm1pw3nw9s1ckw7cqxw961sf";
  };

  patches = [
    # Undo creating ReadWritePaths as instalation target.
    (fetchpatch {
      name = "revert-create-dirs-on-install.patch";
      url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git/patch/?id=5a96c11664eb553bc28a2142af382b190254edbb";
      sha256 = "08gkz3ia1l5xsh3pbx4abimgf7m88wygfpfyg77yi6dwavjqm6cx";
      revert = true;
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    python3Packages.wrapPython
  ];

  buildInputs = [
    ell
    python3Packages.python
    readline
  ];

  pythonPath = [
    python3Packages.dbus-python
    python3Packages.pygobject3
  ];

  configureFlags = [
    "--enable-external-ell"
    "--enable-wired"
    "--localstatedir=/var/"
    "--with-dbus-busdir=${placeholder "out"}/share/dbus-1/system-services/"
    "--with-dbus-datadir=${placeholder "out"}/share/"
    "--with-systemd-modloaddir=${placeholder "out"}/etc/modules-load.d/" # maybe
    "--with-systemd-unitdir=${placeholder "out"}/lib/systemd/system/"
  ];

  postUnpack = ''
    patchShebangs .
  '';

  postInstall = ''
    cp -a test/* $out/bin/
    mkdir -p $out/share
    cp -a doc $out/share/
    cp -a README AUTHORS TODO $out/share/doc/
  '';

  preFixup = ''
    wrapPythonPrograms
  '';

  postFixup = ''
    substituteInPlace $out/share/dbus-1/system-services/net.connman.ead.service \
      --replace /bin/false ${coreutils}/bin/false
    substituteInPlace $out/share/dbus-1/system-services/net.connman.iwd.service \
      --replace /bin/false ${coreutils}/bin/false
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    description = "Wireless daemon for Linux";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
