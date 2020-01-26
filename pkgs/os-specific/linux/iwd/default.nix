{ stdenv
, fetchgit
, fetchpatch
, autoreconfHook
, pkgconfig
, ell
, coreutils
, docutils
, readline
, python3Packages
, systemd
}:

stdenv.mkDerivation rec {
  pname = "iwd";
  version = "1.4";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = version;
    sha256 = "13sig2lbiyi4x74ag37gvdqx5w18w6hmq9hc1ir4a1cqqf50v61v";
  };

  nativeBuildInputs = [
    autoreconfHook
    docutils
    pkgconfig
    python3Packages.wrapPython
  ];

  buildInputs = [
    ell
    python3Packages.python
    readline
    systemd
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
    "--with-systemd-networkdir=${placeholder "out"}/lib/systemd/network/"
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
    maintainers = with maintainers; [ dtzWill fpletz ];
  };
}
