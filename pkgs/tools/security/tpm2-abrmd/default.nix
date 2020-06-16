{ stdenv, fetchurl, lib
, makeWrapper, tpm2-tss, pkgconfig, glib, which, dbus, cmocka }:

stdenv.mkDerivation rec {
  pname = "tpm2-abrmd";
  version = "2.3.2";

  src = fetchurl {
    url = "https://github.com/tpm2-software/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "040d01pdzkj0nc1c0vsf6gfqf28cgil03ix8dasijvhiha4c20nz";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [
    tpm2-tss glib which dbus cmocka
  ];

  enableParallelBuilding = true;

  # Unit tests are currently broken as the check phase attempts to start a dbus daemon etc.
  #configureFlags = [ "--enable-unit" ];
  doCheck = false;

  # Even though tpm2-tss is in the RUNPATH, starting from 2.3.0 abrmd
  # seems to require the path to the device TCTI (used for accessing
  # /dev/tpm0) in it's LD_LIBRARY_PATH
  postFixup = ''
    wrapProgram $out/bin/tpm2-abrmd \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ tpm2-tss ]}"
  '';

  meta = with lib; {
    description = "TPM2 resource manager, accessible via D-Bus";
    homepage = "https://github.com/tpm2-software/tpm2-tools";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lschuermann ];
  };
}
