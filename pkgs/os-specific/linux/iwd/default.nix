{ lib, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, ell
, coreutils
, docutils
, readline
, openssl
, python3Packages
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "iwd";
  version = "1.17";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git";
    rev = version;
    sha256 = "sha256-uWWdKjxctz8fdiIkSiuOYNcZPhxEWDXaA8QPLnd/I9c=";
  };

  outputs = [ "out" "man" ]
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

  checkInputs = [ openssl ];

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

  patches = [
    # Fix failure in test-eapol. Remove when bumping to 1.18
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git/patch/?id=ed10b00afa3f4c087b46d7ba0b60a47bd05d8b39";
      sha256 = "0n8ixrbfh428ajncakcb9kd2n4fw82kw9sfskn1d9ny0lrg39nvg";
    })
  ];

  postUnpack = ''
    mkdir -p iwd/ell
    ln -s ${ell.src}/ell/useful.h iwd/ell/useful.h
    patchShebangs .
  '';

  doCheck = true;

  postInstall = ''
    mkdir -p $out/share
    cp -a doc $out/share/
    cp -a README AUTHORS TODO $out/share/doc/
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
    maintainers = with maintainers; [ dtzWill fpletz maxeaubrey ];
  };
}
