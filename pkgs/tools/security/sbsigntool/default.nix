{ stdenv
, fetchgit, autoconf, automake, pkgconfig, help2man
, utillinux, openssl, libuuid, gnu-efi, libbfd
}:

stdenv.mkDerivation rec {
  name = "sbsigntool-${version}";
  version = "0.5";

  src = fetchgit {
    url = "git://kernel.ubuntu.com/jk/sbsigntool";
    rev = "951ee95a301674c046f55330cd7460e1314deff2";
    sha256 = "1skqrfhvsaay01l94m57sxxqp909rvn07xwmzc6vzzfcnsh6f2yk";
  };

  patches = [ ./autoconf.patch ];

  prePatch = "patchShebangs .";

  nativeBuildInputs = [ autoconf automake pkgconfig help2man ];
  buildInputs = [ utillinux openssl libuuid gnu-efi libbfd ];

  configurePhase = ''
    substituteInPlace configure.ac --replace "@@NIX_GNUEFI@@" "${gnu-efi}"

    lib/ccan.git/tools/create-ccan-tree --build-type=automake lib/ccan "talloc read_write_all build_assert array_size"
    touch AUTHORS
    touch ChangeLog

    echo "SUBDIRS = lib/ccan src docs" >> Makefile.am

    aclocal
    autoheader
    autoconf
    automake --add-missing -Wno-portability

    ./configure --prefix=$out
    '';

  installPhase = ''
    mkdir -p $out
    make install
    '';

  meta = with stdenv.lib; {
    description = "Tools for maintaining UEFI signature databases";
    homepage    = http://jk.ozlabs.org/docs/sbkeysync-maintaing-uefi-key-databases;
    maintainers = [ maintainers.tstrobel ];
    platforms   = [ "x86_64-linux" ]; # Broken on i686
    license     = licenses.gpl3;
  };
}

