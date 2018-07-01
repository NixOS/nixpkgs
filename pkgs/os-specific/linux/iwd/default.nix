{ stdenv, fetchgit, autoreconfHook, readline, python3Packages }:

let
  ell = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     rev = "0.6";
     sha256 = "0cs0a7rjg9gl9gn9sc3b1y8mv2zbjg7rb87mla6kcrknjci76pgm";
  };
in stdenv.mkDerivation rec {
  name = "iwd-${version}";
  version = "0.3";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = version;
    sha256 = "151bqc85vchl1arhl9pyvfashxq886cjrbi6js4csx4vzscbhzzm";
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
