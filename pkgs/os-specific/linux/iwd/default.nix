{ stdenv, fetchgit, autoreconfHook, coreutils, readline, python3Packages }:

let
  ell = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     rev = "0.11";
     sha256 = "0nifa5w6fxy7cagyas2a0zhcppi83yrcsnnp70ls2rc90x4r1ip8";
  };
in stdenv.mkDerivation rec {
  name = "iwd-${version}";
  version = "0.9";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = version;
    sha256 = "1l1jbwsshjbz32s4rf0zfcn3fd16si4y9qa0zaxp00bfzflnpcd4";
  };

  nativeBuildInputs = [
    autoreconfHook
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
