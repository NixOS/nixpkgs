{ lib
, stdenv
, abootimg
, apksigcopier
, apksigner
, apktool
, binutils-unwrapped-all-targets
, bzip2
, cbfstool
, cdrkit
, colord
, colordiff
, coreutils
, cpio
, db
, diffutils
, docutils
, dtc
, e2fsprogs
, enableBloat ? true
, enjarify
, fetchurl
, file
, findutils
, fontforge-fonttools
, ffmpeg
, fpc
, gettext
, ghc
, ghostscriptX
, giflib
, gnumeric
, gnupg
, gnutar
, gzip
, hdf5
, help2man
, html2text
, imagemagick
, installShellFiles
, jdk
, libarchive
, libcaca
, libxmlb
, llvm
, lz4
, lzip
, mono
, ocaml
, odt2txt
, oggvideotools
, openssh
, openssl
, pdftk
, pgpdump
, poppler_utils
, procyon
, python3
, qemu
, R
, radare2
, sng
, sqlite
, squashfsTools
, tcpdump
, ubootTools
, unzip
, wabt
, xmlbeans
, xxd
, xz
, zip
, zstd
  # updater only
, writeScript
}:

# Note: when upgrading this package, please run the list-missing-tools.sh script as described below!
python3.pkgs.buildPythonApplication rec {
  pname = "diffoscope";
  version = "248";

  src = fetchurl {
    url = "https://diffoscope.org/archive/diffoscope-${version}.tar.bz2";
    hash = "sha256-Lub+SIr0EyY4YmPsoLXWavXJhcpmK5VRb6eEnozZ0XQ=";
  };

  outputs = [
    "out"
    "man"
  ];

  patches = [
    ./ignore_links.patch
    ./fix-test_fit.patch
  ];

  postPatch = ''
    # Upstream doesn't provide a PKG-INFO file
    sed -i setup.py -e "/'rpm-python',/d"

    # When generating manpage, use the installed version
    substituteInPlace doc/Makefile --replace "../bin" "$out/bin"
  '';

  nativeBuildInputs = [
    docutils
    help2man
    installShellFiles
  ];

  # Most of the non-Python dependencies here are optional command-line tools for various file-format parsers.
  # To help figuring out what's missing from the list, run: ./pkgs/tools/misc/diffoscope/list-missing-tools.sh
  #
  # Still missing these tools:
  # aapt2
  # dexdump
  # docx2txt
  # getfacl
  # lipo
  # otool
  # r2pipe
  #
  # We filter automatically all packages for the host platform (some dependencies are not supported on Darwin, aarch64, etc.).
  pythonPath = lib.filter (lib.meta.availableOn stdenv.hostPlatform) ([
    binutils-unwrapped-all-targets
    bzip2
    cdrkit
    colordiff
    coreutils
    cpio
    db
    diffutils
    dtc
    e2fsprogs
    file
    findutils
    fontforge-fonttools
    gettext
    gnutar
    gzip
    html2text
    libarchive
    libxmlb
    lz4
    lzip
    openssl
    pgpdump
    sng
    sqlite
    squashfsTools
    unzip
    xxd
    xz
    zip
    zstd
  ]
  ++ (with python3.pkgs; [
    argcomplete
    debian
    defusedxml
    jsbeautifier
    jsondiff
    libarchive-c
    progressbar33
    pypdf2
    python-magic
    pyxattr
    rpm
    tlsh
  ])
  ++ lib.optionals enableBloat (
    [
      abootimg
      apksigcopier
      apksigner
      apktool
      cbfstool
      colord
      enjarify
      ffmpeg
      fpc
      ghc
      ghostscriptX
      giflib
      gnupg
      hdf5
      imagemagick
      jdk
      libcaca
      llvm
      mono
      ocaml
      odt2txt
      openssh
      pdftk
      poppler_utils
      procyon
      qemu
      R
      radare2
      tcpdump
      ubootTools
      wabt
      xmlbeans
    ]
    ++ (with python3.pkgs; [
      androguard
      binwalk
      guestfs
      h5py
      pdfminer-six
    ])
    # oggvideotools is broken on Darwin, please put it back when it will be fixed?
    ++ lib.optionals stdenv.isLinux [ oggvideotools ]
    # This doesn't work on aarch64-darwin
    ++ lib.optionals (stdenv.hostPlatform != "aarch64-darwin") [ gnumeric ]
  ));

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ] ++ pythonPath;

  pytestFlagsArray = [
    # Always show more information when tests fail
    "-vv"
  ];

  postInstall = ''
    make -C doc
    installManPage doc/diffoscope.1
  '';

  disabledTests = [
    "test_sbin_added_to_path"
    "test_diff_meta"
    "test_diff_meta2"

    # Fails because it fails to determine llvm version
    "test_item3_deflate_llvm_bitcode"
  ] ++ lib.optionals stdenv.isDarwin [
    # Disable flaky tests on Darwin
    "test_non_unicode_filename"
    "test_listing"
    "test_symlink_root"
  ];

  # Flaky tests on Darwin
  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "tests/comparators/test_git.py"
    "tests/comparators/test_java.py"
    "tests/comparators/test_uimage.py"
    "tests/comparators/test_device.py"
    "tests/comparators/test_macho.py"
  ];

  passthru = {
    updateScript = writeScript "update-diffoscope" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of "Latest release: 198 (31 Dec 2021)"'.
      newVersion="$(curl -s https://diffoscope.org/ | pcregrep -o1 'Latest release: ([0-9]+)')"
      update-source-version ${pname} "$newVersion"
    '';
  };

  meta = with lib; {
    description = "Perform in-depth comparison of files, archives, and directories";
    longDescription = ''
      diffoscope will try to get to the bottom of what makes files or directories
      different. It will recursively unpack archives of many kinds and transform
      various binary formats into more human readable form to compare them. It can
      compare two tarballs, ISO images, or PDF just as easily. The differences can
      be shown in a text or HTML report.

      diffoscope is developed as part of the "reproducible builds" Debian
      project and was formerly known as "debbindiff".
    '';
    homepage = "https://diffoscope.org/";
    changelog = "https://diffoscope.org/news/diffoscope-${version}-released/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dezgeg danielfullmer raitobezarius ];
    platforms = platforms.unix;
  };
}
