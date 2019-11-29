{ stdenv
, fetchgit, autoconf, automake, pkgconfig, help2man
, openssl, libuuid, gnu-efi, libbfd
}:

stdenv.mkDerivation {
  pname = "sbsigntool";
  version = "0.9.1";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/jejb/sbsigntools.git";
    rev = "v0.9.1";
    sha256 = "098gxmhjn8acxjw5bq59wq4xhgkpx1xn8kjvxwdzpqkwq9ivrsbp";
  };

  patches = [ ./autoconf.patch ];

  prePatch = "patchShebangs .";

  nativeBuildInputs = [ autoconf automake pkgconfig help2man ];
  buildInputs = [ openssl libuuid libbfd gnu-efi ];

  configurePhase = ''
    substituteInPlace configure.ac --replace "@@NIX_GNUEFI@@" "${gnu-efi}"

    lib/ccan.git/tools/create-ccan-tree --build-type=automake lib/ccan "talloc read_write_all build_assert array_size endian"
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

