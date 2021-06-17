{ stdenv, lib, fetchurl,
  pkgconfig, chrpath, autoreconfHook,
  autoPatchelfHook,
  openssl, curl, dbus, nss, at-spi2-core, gtk2, xorg,
  python3Packages
}:

stdenv.mkDerivation rec {
  pname = "warsaw-bin";
  version = "1.13.1.2";

  src = fetchurl {
    url = "https://cloud.gastecnologia.com.br/bb/downloads/ws/warsaw_64_installer.run";
    sha256 = "0h2gn39iszdzkchscjiy2gp5j0n0hnyx5adsx6snmv8aj6i3gmnq";
  };

  nativeBuildInputs = [
    pkgconfig
    chrpath
    autoreconfHook
    autoPatchelfHook
    python3Packages.wrapPython
  ];

  buildInputs = [
    openssl
    curl
    dbus
    nss
    at-spi2-core
    gtk2
    python3Packages.python
  ];

  unpackPhase = ''
    runHook preUnpack

    # Extracts the binary content starting from the line number "L"
    # (L was informed within the installer)
    L=363
    tail -n +$L ${src} | tar -zxf -
    cd tmp/warsaw_x64

    runHook postUnpack
  '';

  postPatch = ''
    substituteInPlace Makefile.am \
      --replace /usr/share $out/share \
      --replace /etc $out/etc
  '';

  postFixup = ''
    wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    description = "Banking security tool developed by GAS Tecnologia";
    homepage = "https://seg.bb.com.br";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ romildo ];
  };
}
