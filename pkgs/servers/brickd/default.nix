{ stdenv, fetchgit, libusb, pkgconfig, pmutils, udev} :

let

version = "2.1.1";
daemonlib = fetchgit {
    url = "https://github.com/Tinkerforge/daemonlib.git";
    rev = "refs/tags/brickd-${version}";
    sha256 = "097kaz7d0rzg0ijvcna3y620k3m5fgxpqsac5gbhah8pd7vlj1a4";
  };

in

stdenv.mkDerivation rec {
  name = "brickd-${version}";

  src = fetchgit {
    url = "git://github.com/Tinkerforge/brickd.git";
    rev = "refs/tags/v${version}";
    sha256 = "0m2q01sbgf8z4559jpr6k3jivb8x98vxv1fhgx8nfcjbwz1q83gb";
  };

  buildInputs = [ libusb pkgconfig pmutils udev ];

  # shell thing didn't work so i replaced it using nix
  prePatch = ''
    substituteInPlace src/brickd/Makefile --replace 'PKG_CONFIG := $(shell which pkg-config 2> /dev/null)' "PKG_CONFIG := $pkgconfig/bin/pkg_config";
  '';

  buildPhase = ''
    export
    # build the brickd binary
    mkdir src/daemonlib
    cp -r ${daemonlib}/* src/daemonlib
    cd src/brickd
    make

    # build and execute the unit tests
    cd ../tests
    make
    for i in array_test base58_test node_test putenv_test queue_test sha1_test; do
      echo "running unit test $i:"
      ./$i
    done
  '';

  installPhase = ''
    cd ../brickd
    mkdir -p $out/bin
    cp brickd $out/bin/brickd
  '';

  meta = {
    homepage = http://www.tinkerforge.com/;
    description = "A daemon (or service on Windows) that acts as a bridge between the Bricks/Bricklets and the API bindings for the different programming languages";
    maintainers = [ stdenv.lib.maintainers.qknight ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
