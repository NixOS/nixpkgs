{ stdenv
, fetchgit
, fetchpatch
, autoreconfHook
, pkgconfig
, ell
, coreutils
, docutils
, readline
, openssl
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "iwd";
  version = "1.10";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git";
    rev = version;
    sha256 = "0gzpdgfwzlqj2n3amf2zhi2hlpa412878yphgx79y6b5gn1y1lm2";
  };

  outputs = [ "out" "man" ]
    ++ stdenv.lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "test";

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
  ];

  checkInputs = [ openssl ];

  # wrapPython wraps the scripts in $test. They pull in gobject-introspection,
  # which doesn't cross-compile.
  pythonPath = stdenv.lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
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

  doCheck = true;

  postInstall = ''
    mkdir -p $out/share
    cp -a doc $out/share/
    cp -a README AUTHORS TODO $out/share/doc/
  '' + stdenv.lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
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

  meta = with stdenv.lib; {
    homepage = "https://git.kernel.org/pub/scm/network/wireless/iwd.git";
    description = "Wireless daemon for Linux";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill fpletz ];
  };
}
