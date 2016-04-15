{ stdenv, fetchurl, dpkg, glibc, gcc, libuuid }:

let
  srcs = import ./srcs.nix { inherit fetchurl; };
in
stdenv.mkDerivation {
  name = "fusionio-util-${srcs.version}";

  nativeBuildInputs = [ dpkg ];

  buildCommand = ''
    dpkg-deb -R ${srcs.libvsl} $TMPDIR
    dpkg-deb -R ${srcs.util} $TMPDIR

    rm $TMPDIR/usr/bin/fio-{bugreport,sanitize}

    mkdir -p $out
    cp -r $TMPDIR/{etc,usr/{bin,lib,share}} $out
    for BIN in $(find $out/bin -type f); do
      echo Patching $BIN
      patchelf --set-interpreter "${glibc.out}/lib/ld-linux-x86-64.so.2" --set-rpath "${glibc.out}/lib:${gcc.cc}/lib:${libuuid}/lib:$out/lib" $BIN

      # Test our binary to see if it was correctly patched
      set +e
      $BIN --help >/dev/null 2>&1
      ST="$?"
      set -e
      if [ "$ST" -ge "10" ]; then
        echo "Failed testing $BIN"
        exit 1;
      fi
    done
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = http://fusionio.com;
    description = "Fusionio command line utilities";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    broken = stdenv.system != "x86_64-linux";
    maintainers = with maintainers; [ wkennington ];
  };
}
