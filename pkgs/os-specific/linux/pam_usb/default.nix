{ stdenv, fetchurl, makeWrapper, dbus, libxml2, pam, pkgconfig, pmount, pythonPackages, writeScript }:

let

  # Search in the environment if the same program exists with a set uid or
  # set gid bit.  If it exists, run the first program found, otherwise run
  # the default binary.
  useSetUID = drv: path:
    let
      name = baseNameOf path;
      bin = "${drv}${path}";
    in assert name != "";
      writeScript "setUID-${name}" ''
        #!${stdenv.shell}
        inode=$(stat -Lc %i ${bin})
        for file in $(type -ap ${name}); do
          case $(stat -Lc %a $file) in
            ([2-7][0-7][0-7][0-7])
              if test -r "$file".real; then
                orig=$(cat "$file".real)
                if test $inode = $(stat -Lc %i "$orig"); then
                  exec "$file" "$@"
                fi
              fi;;
          esac
        done
        exec ${bin} "$@"
      '';

  pmountBin = useSetUID pmount "/bin/pmount";
  pumountBin = useSetUID pmount "/bin/pumount";
  inherit (pythonPackages) python dbus-python;
in

stdenv.mkDerivation rec {
  name = "pam_usb-0.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/pamusb/${name}.tar.gz";
    sha256 = "1g1w0s9d8mfld8abrn405ll5grv3xgs0b0hsganrz6qafdq9j7q1";
  };

  buildInputs = [
    makeWrapper
    # pam_usb dependencies
    dbus libxml2 pam pmount pkgconfig
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
        --prefix PYTHONPATH : "$(toPythonPath ${dbus-python})"
    done
  '';

  meta = {
    homepage = http://pamusb.org/;
    description = "Authentication using USB Flash Drives";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
