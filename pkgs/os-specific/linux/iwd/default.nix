{ stdenv, fetchgit, autoreconfHook, readline, python3Packages }:

let
  ell = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     rev = "0.7";
     sha256 = "095psnpfdy107z5qgi5zw0icqxa44dfx02lza3pd8j4ybj57n0l7";
  };
in stdenv.mkDerivation rec {
  name = "iwd-${version}";
  version = "0.4";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = version;
    sha256 = "1hib256jm70k6jlx486jrcv0iip52divbzhvb0f455yh28qfk0hs";
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
    "--localstatedir=/var"
    "--disable-systemd-service"
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

  meta = with stdenv.lib; {
    homepage = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    description = "Wireless daemon for Linux";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
