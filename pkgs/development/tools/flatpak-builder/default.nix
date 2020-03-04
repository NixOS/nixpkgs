{ stdenv
, fetchurl
, substituteAll
, nixosTests

, autoreconfHook
, docbook_xml_dtd_412
, docbook_xml_dtd_42
, docbook_xml_dtd_43
, docbook_xsl
, gettext
, libxml2
, libxslt
, pkgconfig
, xmlto

, acl
, bazaar
, binutils
, bzip2
, coreutils
, cpio
, curl
, elfutils
, flatpak
, gitMinimal
, glib
, glibcLocales
, gnumake
, gnupg
, gnutar
, json-glib
, libcap
, libdwarf
, libsoup
, libyaml
, ostree
, patch
, python2
, rpm
, unzip
}:

let
  installed_testdir = "${placeholder "installedTests"}/libexec/installed-tests/flatpak-builder";
  installed_test_metadir = "${placeholder "installedTests"}/share/installed-tests/flatpak-builder";
  version = "1.0.9";
in stdenv.mkDerivation rec {
  pname = "flatpak-builder";
  inherit version;

  outputs = [ "out" "doc" "man" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak-builder/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "00qd770qjsiyd8qhhhyn7zg6jyi283ix5dhjzcfdn9yr3h53kvyn";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook_xml_dtd_412
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xsl
    gettext
    libxml2
    libxslt
    pkgconfig
    xmlto
  ];

  buildInputs = [
    acl
    bzip2
    curl
    elfutils
    flatpak
    glib
    json-glib
    libcap
    libdwarf
    libsoup
    libxml2
    libyaml
    ostree
  ];

  patches = [
    # patch taken from gtk_doc
    ./respect-xml-catalog-files-var.patch
    (substituteAll {
      src = ./fix-paths.patch;
      bzr = "${bazaar}/bin/bzr";
      cp = "${coreutils}/bin/cp";
      patch = "${patch}/bin/patch";
      tar = "${gnutar}/bin/tar";
      unzip = "${unzip}/bin/unzip";
      rpm2cpio = "${rpm}/bin/rpm2cpio";
      cpio = "${cpio}/bin/cpio";
      git = "${gitMinimal}/bin/git";
      rofilesfuse = "${ostree}/bin/rofiles-fuse";
      strip = "${binutils}/bin/strip";
      eustrip = "${elfutils}/bin/eu-strip";
      euelfcompress = "${elfutils}/bin/eu-elfcompress";
    })

    # The test scripts in Flatpak repo were updated so we are basing
    # this on our patch for Flatpak 0.99.
    (substituteAll {
      src = ./fix-test-paths.patch;
      inherit glibcLocales python2;
    })
  ];

  configureFlags = [
    "--enable-installed-tests"
  ];

  makeFlags = [
    "installed_testdir=${installed_testdir}"
    "installed_test_metadir=${installed_test_metadir}"
  ];

  # Some scripts used by tests  need to use shebangs that are available in Flatpak runtimes.
  dontPatchShebangs = true;

  # Installed tests
  postFixup = ''
    for file in ${installed_testdir}/{test-builder.sh,test-builder-python.sh}; do
      patchShebangs $file
    done
  '';

  passthru = {
    installedTestsDependencies = [
      gnupg
      ostree
      python2
      gnumake
    ];

    tests = {
      installedTests = nixosTests.installed-tests.flatpak-builder;
    };
  };

  meta = with stdenv.lib; {
    description = "Tool to build flatpaks from source";
    homepage = https://flatpak.org/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
