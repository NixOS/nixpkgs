{ lib, stdenv
, fetchgit
, fetchpatch
, autoreconfHook
, pkg-config
, ell
, coreutils
, docutils
, readline
, openssl
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "iwd";
  version = "2.8";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git";
    rev = version;
    sha256 = "sha256-i+2R8smgLXooApj0Z5e03FybhYgw1X/kIsJkrDzW8y4=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-52161.patch";
      url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git/patch/?id=6415420f1c92012f64063c131480ffcef58e60ca";
      hash = "sha256-bN5mxdWDyKEC2IyyG2vlzTEAL57C4uC7GAJA3jSXJHg=";
    })
    (fetchpatch {
      name = "netdev-buffer-overflow-32-byte-ssid.patch";
      url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git/patch/?id=8d68b33e763aced6d419df9f6534760d2c890279";
      hash = "sha256-BSduzwVUTEcqjVwD88qJYgItApcQZwU43u9gbNMDs8I=";
    })
    (fetchpatch {
      name = "erp-buffer-overflow-32-byte-ssid.patch";
      url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git/patch/?id=bdaae53cf828a1f6ea7a7b57d7d6ebcc7b70ac43";
      hash = "sha256-K/Ib0azlZ0UlFqcqs+8dSfj0hh0j0dZYpfB9f6tEqc8=";
    })
  ];

  outputs = [ "out" "man" "doc" ]
    ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "test";

  nativeBuildInputs = [
    autoreconfHook
    docutils
    pkg-config
    python3Packages.wrapPython
  ];

  buildInputs = [
    ell
    python3Packages.python
    readline
  ];

  nativeCheckInputs = [ openssl ];

  # wrapPython wraps the scripts in $test. They pull in gobject-introspection,
  # which doesn't cross-compile.
  pythonPath = lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
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
    mkdir -p iwd/ell
    ln -s ${ell.src}/ell/useful.h iwd/ell/useful.h
    ln -s ${ell.src}/ell/asn1-private.h iwd/ell/asn1-private.h
    patchShebangs .
  '';

  doCheck = true;

  postInstall = ''
    mkdir -p $doc/share/doc
    cp -a doc $doc/share/doc/iwd
    cp -a README AUTHORS TODO $doc/share/doc/iwd
  '' + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    mkdir -p $test/bin
    cp -a test/* $test/bin/
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

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/network/wireless/iwd.git";
    description = "Wireless daemon for Linux";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill fpletz amaxine ];
  };
}
