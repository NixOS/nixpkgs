{ stdenv, fetchgit, autoreconfHook, pkgconfig, coreutils, readline, python3Packages }:

let
  ell = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     rev = "0.15";
     sha256 = "1jwk5gxcs964ddca9asw6fvc4h9q8d2x1y3linfi11b5vf30bghn";
  };
in stdenv.mkDerivation rec {
  name = "iwd-${version}";
  version = "0.12";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = version;
    sha256 = "156zq3zqa2vfmvy3yv9lng23mhrhlgwh0p2x3fcn10nkks9q89pn";
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

  # Enable when it works again
  enableParallelBuilding = false;

  configureFlags = [
    "--with-dbus-datadir=$(out)/etc/"
    "--with-dbus-busdir=$(out)/usr/share/dbus-1/system-services/"
    "--with-systemd-unitdir=$(out)/lib/systemd/system/"
    "--localstatedir=/var/"
    "--enable-wired"
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
    substituteInPlace $out/usr/share/dbus-1/system-services/net.connman.ead.service \
                      --replace /bin/false ${coreutils}/bin/false
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
