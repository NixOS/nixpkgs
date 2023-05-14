{ lib, stdenv
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
, pkg-config
, xmlto

, acl
, breezy
, binutils
, bzip2
, coreutils
, cpio
, curl
, debugedit
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
in stdenv.mkDerivation rec {
  pname = "flatpak-builder";
  version = "1.2.3";

  outputs = [ "out" "doc" "man" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak-builder/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-4leCWkf3o+ceMPsPgPLZrG5IAfdG9VLfrw5WTj7jUcg=";
  };

  patches = [
    # patch taken from gtk_doc
    ./respect-xml-catalog-files-var.patch

    # Hardcode paths
    (substituteAll {
      src = ./fix-paths.patch;
      brz = "${breezy}/bin/brz";
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
      inherit glibcLocales;
      # FIXME use python3 for tests that rely on python2
      # inherit python2;
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    docbook_xml_dtd_43
    docbook_xsl
    gettext
    libxml2
    libxslt
    pkg-config
    xmlto
  ];

  buildInputs = [
    acl
    bzip2
    curl
    debugedit
    elfutils
    flatpak
    glib
    json-glib
    libcap
    libsoup
    libxml2
    libyaml
    ostree
  ];

  configureFlags = [
    "--enable-installed-tests"
    "--with-system-debugedit"
  ];

  makeFlags = [
    "installed_testdir=${installed_testdir}"
    "installed_test_metadir=${installed_test_metadir}"
  ];

  # Some scripts used by tests  need to use shebangs that are available in Flatpak runtimes.
  dontPatchShebangs = true;

  enableParallelBuilding = true;

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
      # FIXME python2
      gnumake
    ];

    tests = {
      installedTests = nixosTests.installed-tests.flatpak-builder;
    };
  };

  meta = with lib; {
    description = "Tool to build flatpaks from source";
    homepage = "https://github.com/flatpak/flatpak-builder";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
