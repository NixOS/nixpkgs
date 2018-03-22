{ stdenv, fetchgit, autoreconfHook, readline, python3Packages }:

let
  ell = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     rev = "8192131685be0f27d6f51b14b78ef93fa7f3c692";
     sha256 = "1k74qz3w0l4zq8llrxc4p62xy0c0n33f260vy3d14wx5rhvf0544";
  };
in stdenv.mkDerivation rec {
  name = "iwd-unstable-2017-12-14";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = "cf3372235c4592ca7366b27548abc4e89a982414";
    sha256 = "0dg28j919w1v8sqr6jdj12c233rsjzd2jzkcpag1hx2h3g35hnlz";
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
    "--with-dbusconfdir=$(out)/etc/"
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
