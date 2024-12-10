{
  lib,
  mkDerivation,
  fetchurl,
  fetchpatch,
  cmake,
  flatbuffers,
  gettext,
  pkg-config,
  libdigidocpp,
  opensc,
  openldap,
  openssl,
  pcsclite,
  qtbase,
  qtsvg,
  qttools,
}:

mkDerivation rec {
  pname = "qdigidoc";
  version = "4.6.0";

  src = fetchurl {
    url = "https://github.com/open-eid/DigiDoc4-Client/releases/download/v${version}/qdigidoc4-${version}.tar.gz";
    hash = "sha256-szFLY9PpZMMYhfV5joueShfu92YDVmcCC3MOWIOAKVg=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/open-eid/DigiDoc4-Client/commit/bb324d18f0452c2ab1b360ff6c42bb7f11ea60d7.patch";
      hash = "sha256-JpaU9inupSDsZKhHk+sp5g+oUynVFxR7lshjTXoFIbU=";
    })

    # Regularly update this with what's on https://src.fedoraproject.org/rpms/qdigidoc/blob/rawhide/f/sandbox.patch
    # This prevents attempts to download TSL lists inside the build sandbox.
    # The list files are regularly updated (get new signatures), though this also happens at application runtime.
    ./sandbox.patch
  ];

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    qttools
  ];

  buildInputs = [
    flatbuffers
    libdigidocpp
    opensc
    openldap
    openssl
    pcsclite
    qtbase
    qtsvg
  ];

  # qdigidoc4's `QPKCS11::reload()` dlopen()s "opensc-pkcs11.so" in QLibrary,
  # i.e. OpenSC's module is searched for in libQt5Core's DT_RUNPATH and fixing
  # qdigidoc4's DT_RUNPATH has no effect on Linux (at least OpenBSD's ld.so(1)
  # searches the program's runtime path as well).
  # LD_LIBRARY_PATH takes precedence for all calling objects, see dlopen(3).
  # https://github.com/open-eid/cmake/pull/35 might be an alternative.
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${opensc}/lib/pkcs11/"
  ];

  meta = with lib; {
    description = "Qt-based UI for signing and verifying DigiDoc documents";
    mainProgram = "qdigidoc4";
    homepage = "https://www.id.ee/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      flokli
      mmahut
      yana
    ];
  };
}
