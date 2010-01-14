{stdenv, fetchurl, makeWrapper, useSetUID, dbus, libxml2, pam, hal, pkgconfig, pmount, python, pythonDBus}:

let
  pmountBin = useSetUID pmount "/bin/pmount";
  pumountBin = useSetUID pmount "/bin/pumount";
in

stdenv.mkDerivation {
  name = "pam_usb-0.4.2";

  src = fetchurl {
    url = mirror://sourceforge/pamusb/files/pam_usb/pam_usb-0.4.2/pam_usb-0.4.2.tar.gz;
    sha256 = "736afced7482c7c5d47127285f7defe0a304a6136a0090588fa8698d385ba202";
  };

  buildInputs = [
    makeWrapper
    # pam_usb dependencies
    dbus libxml2 pam hal pmount pkgconfig
    # pam_usb's tools dependencies
    python
    # cElementTree is included with python 2.5 and later.
  ];

  preBuild = ''
    makeFlagsArray=(DESTDIR=$out)
    substituteInPlace ./src/volume.c \
      --replace 'pmount' '${pmountBin}' \
      --replace 'pumount' '${pumountBin}'
  '';

  # pmount is append to the PATH because pmounts binaries should have a set uid bit.
  postInstall = ''
    mv $out/usr/* $out/. # fix color */
    rm -rf $out/usr
    for prog in $out/bin/pamusb-conf $out/bin/pamusb-agent; do
      substituteInPlace $prog --replace '/usr/bin/env python' '/bin/python'
      wrapProgram $prog \
        --prefix PYTHONPATH : "$(toPythonPath ${pythonDBus})"
    done
  '';

  meta = {
    homepage = http://pamusb.org/;
    description = "Authentication using USB Flash Drives";
    license = "GPLv2";
  };
}
