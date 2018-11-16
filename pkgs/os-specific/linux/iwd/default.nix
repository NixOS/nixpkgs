{ stdenv, fetchgit, autoreconfHook, pkgconfig, coreutils, readline, python3Packages }:

let
  ell = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     rev = "0.14";
     sha256 = "13jlmdk47pscmfs3c12awfwr3m6ka4fh6fyr9cl1bmqdpwqmmmk6";
  };
in stdenv.mkDerivation rec {
  name = "iwd-${version}";
  version = "0.11";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = version;
    sha256 = "0q79rdj3h16xdf0g2jdsvb2141z36z89vgzq0qn31pxzhgxdgf7j";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    python3Packages.wrapPython
  ];

  buildInputs = [
    readline
    python3Packages.python
  ];

  pythonPath = [
    python3Packages.dbus-python
    python3Packages.pygobject3
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-dbus-datadir=$(out)/etc/"
    "--with-dbus-busdir=$(out)/usr/share/dbus-1/system-services/"
    "--with-systemd-unitdir=$(out)/lib/systemd/system/"
    "--localstatedir=/var/"
  ];

  postUnpack = ''
    ln -s ${ell} ell
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
    substituteInPlace $out/usr/share/dbus-1/system-services/net.connman.iwd.service \
                      --replace /bin/false ${coreutils}/bin/false
  '';

  meta = with stdenv.lib; {
    homepage = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    description = "Wireless daemon for Linux";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
