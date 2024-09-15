{
  lib,
  stdenv,
  abootimg,
  acl,
  apksigcopier,
  apksigner,
  apktool,
  binutils-unwrapped-all-targets,
  bzip2,
  cbfstool,
  cdrkit,
  colord,
  colordiff,
  coreutils,
  cpio,
  db,
  diffutils,
  docutils,
  dtc,
  e2fsprogs,
  enableBloat ? true,
  enjarify,
  fetchurl,
  file,
  findutils,
  fontforge-fonttools,
  ffmpeg,
  fpc,
  gettext,
  ghc,
  ghostscriptX,
  giflib,
  gnumeric,
  gnupg,
  gnutar,
  gzip,
  hdf5,
  help2man,
  html2text,
  imagemagick,
  installShellFiles,
  jdk,
  libarchive,
  libcaca,
  libxmlb,
  llvm,
  lz4,
  lzip,
  mono,
  ocaml,
  odt2txt,
  oggvideotools,
  openssh,
  openssl,
  pdftk,
  pgpdump,
  poppler_utils,
  procyon,
  python3,
  qemu,
  R,
  sng,
  sqlite,
  squashfsTools,
  tcpdump,
  ubootTools,
  unzip,
  wabt,
  xmlbeans,
  xxd,
  xz,
  zip,
  zstd,
  # updater only
  writeScript,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      # version 4 or newer would log the followng error but tests currently don't fail because radare2 is disabled
      # ValueError: argument TNULL is not a TLSH hex string
      tlsh = prev.tlsh.overridePythonAttrs (
        { src, ... }:
        let
          version = "3.19.1";
        in
        {
          inherit version;
          src = src.override {
            rev = version;
            hash = "sha256-ZYEjT/yShfA4+zpbGOtaFOx1nSSOWPtMvskPhHv3c9U=";
          };
        }
      );
    };
  };
in

# Note: when upgrading this package, please run the list-missing-tools.sh script as described below!
python.pkgs.buildPythonApplication rec {
  pname = "diffoscope";
  version = "277";

  src = fetchurl {
    url = "https://diffoscope.org/archive/diffoscope-${version}.tar.bz2";
    hash = "sha256-ZDW9EzoQG5b0dmydKi850rdf0a8UWKFjrk+toxgBicY=";
  };

  outputs = [
    "out"
    "man"
  ];

  patches = [ ./ignore_links.patch ];

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
  # Android-specific tools:
  # aapt2
  # dexdump
  # Darwin-specific tools:
  # lipo
  # otool
  # Other tools:
  # docx2txt <- makes tests broken:
  # > FAILED tests/comparators/test_docx.py::test_diff - IndexError: list index out of range
  # > FAILED tests/comparators/test_docx.py::test_compare_non_existing - AssertionError
  # radare2
  # > FAILED tests/comparators/test_elf_decompiler.py::test_ghidra_diff - IndexError: list index out of range
  # > FAILED tests/comparators/test_elf_decompiler.py::test_radare2_diff - AssertionError
  # > FAILED tests/comparators/test_macho_decompiler.py::test_ghidra_diff - assert 0 == 1
  # > FAILED tests/comparators/test_macho_decompiler.py::test_radare2_diff - AssertionError
  #
  # We filter automatically all packages for the host platform (some dependencies are not supported on Darwin, aarch64, etc.).
  # Packages which are marked broken for a platform are not automatically filtered to avoid accidentally removing them without noticing it.
  pythonPath = lib.filter (lib.meta.availableOn stdenv.hostPlatform) (
    [
      acl
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
    ++ (with python.pkgs; [
      argcomplete
      debian
      defusedxml
      jsbeautifier
      jsondiff
      libarchive-c
      progressbar33
      pypdf
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
        tcpdump
        ubootTools
        wabt
        xmlbeans
      ]
      ++ (with python.pkgs; [
        androguard
        binwalk
        guestfs
        h5py
        pdfminer-six
        r2pipe
        # docx2txt, nixpkgs packages another project named the same, which does not work
      ])
      # oggvideotools is broken on Darwin, please put it back when it will be fixed?
      ++ lib.optionals stdenv.isLinux [ oggvideotools ]
      # This doesn't work on aarch64-darwin
      ++ lib.optionals (stdenv.hostPlatform.system != "aarch64-darwin") [ gnumeric ]
    )
  );

  nativeCheckInputs = with python.pkgs; [ pytestCheckHook ] ++ pythonPath;

  pytestFlagsArray = [
    # Always show more information when tests fail
    "-vv"
  ];

  postInstall = ''
    make -C doc
    installManPage doc/diffoscope.1
  '';

  disabledTests =
    [
      "test_sbin_added_to_path"
      "test_diff_meta"
      "test_diff_meta2"

      # Fails because it fails to determine llvm version
      "test_item3_deflate_llvm_bitcode"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # Disable flaky tests on Darwin
      "test_non_unicode_filename"
      "test_listing"
      "test_symlink_root"

      # Appears to be a sandbox related issue
      "test_trim_stderr_in_command"
      # Seems to be a bug caused by having different versions of rdata than
      # expected. Will file upstream.
      "test_item_rdb"
      # Caused by getting an otool command instead of llvm-objdump. Could be Nix
      # setup, could be upstream bug. Will file upstream.
      "test_libmix_differences"
    ];

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
    maintainers = with maintainers; [
      dezgeg
      danielfullmer
      raitobezarius
    ];
    platforms = platforms.unix;
    mainProgram = "diffoscope";
  };
}
