{ stdenv, fetchgit, fetchpatch, pkgconfig, udev, utillinux, libuuid
, thin-provisioning-tools, libaio
, enable_dmeventd ? false }:

let
  pname = "lvm2";
  version = "2.03.01";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchgit {
    url = "git://sourceware.org/git/lvm2.git";
    rev = "v${builtins.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "0jlaswf1srdxiqpgpp97j950ddjds8z0kr4pbwmal2za2blrgvbl";
  };

  configureFlags = [
    "--disable-readline"
    "--enable-pkgconfig"
    "--enable-applib"
    "--enable-cmdlib"
  ] ++ stdenv.lib.optional enable_dmeventd " --enable-dmeventd"
  ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ] ++
  stdenv.lib.optionals (udev != null) [
    "--enable-udev_rules"
    "--enable-udev_sync"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ udev libuuid thin-provisioning-tools libaio ];

  preConfigure = ''
    substituteInPlace scripts/lvm2_activation_generator_systemd_red_hat.c \
      --replace /usr/bin/udevadm /run/current-system/systemd/bin/udevadm

    sed -i /DEFAULT_SYS_DIR/d Makefile.in
    sed -i /DEFAULT_PROFILE_DIR/d conf/Makefile.in
    substituteInPlace make.tmpl.in --replace "@systemdsystemunitdir@" "${placeholder "out"}/lib/systemd/system"
    substituteInPlace libdm/make.tmpl.in --replace "@systemdsystemunitdir@" "${placeholder "out"}/lib/systemd/system"
  '';

  patches = stdenv.lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      name = "fix-stdio-usage.patch";
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/lvm2/fix-stdio-usage.patch?h=3.7-stable&id=31bd4a8c2dc00ae79a821f6fe0ad2f23e1534f50";
      sha256 = "0m6wr6qrvxqi2d2h054cnv974jq1v65lqxy05g1znz946ga73k3p";
    })
    (fetchpatch {
      name = "mallinfo.patch";
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/lvm2/mallinfo.patch?h=3.7-stable&id=31bd4a8c2dc00ae79a821f6fe0ad2f23e1534f50";
      sha256 = "0g6wlqi215i5s30bnbkn8w7axrs27y3bnygbpbnf64wwx7rxxlj0";
    })
    (fetchpatch {
      name = "mlockall-default-config.patch";
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/lvm2/mlockall-default-config.patch?h=3.7-stable&id=31bd4a8c2dc00ae79a821f6fe0ad2f23e1534f50";
      sha256 = "1ivbj3sphgf8n1ykfiv5rbw7s8dgnj5jcr9jl2v8cwf28lkacw5l";
    })
  ];

  doCheck = false; # requires root

  makeFlags = stdenv.lib.optionals (udev != null) [
    "SYSTEMD_GENERATOR_DIR=$(out)/lib/systemd/system-generators"
  ];

  # To prevent make install from failing.
  installFlags = [
    "OWNER="
    "GROUP="
    "confdir=$(out)/etc"
  ];

  # Install systemd stuff.
  installTargets = [ "install" ]
                   ++ stdenv.lib.optionals (udev != null) [ "install_systemd_generators" "install_systemd_units" "install_tmpfiles_configuration"];

  meta = with stdenv.lib; {
    homepage = http://sourceware.org/lvm2/;
    description = "Tools to support Logical Volume Management (LVM) on Linux";
    platforms = platforms.linux;
    license = with licenses; [ gpl2 bsd2 lgpl21 ];
    maintainers = with maintainers; [ raskin ];
  };
}
