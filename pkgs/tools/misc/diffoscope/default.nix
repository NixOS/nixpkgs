{ lib, stdenv, fetchurl, python3Packages, docutils, help2man, installShellFiles
, abootimg, acl, apksigner, apktool, binutils-unwrapped, bzip2, cbfstool, cdrkit, colord, colordiff, coreutils, cpio, db, diffutils, dtc
, e2fsprogs, file, findutils, fontforge-fonttools, ffmpeg, fpc, gettext, ghc, ghostscriptX, giflib, gnumeric, gnupg, gnutar
, gzip, hdf5, imagemagick, jdk, libarchive, libcaca, llvm, lz4, mono, openssh, openssl, pdftk, pgpdump, poppler_utils, qemu, R
, radare2, sng, sqlite, squashfsTools, tcpdump, odt2txt, unzip, wabt, xxd, xz, zip, zstd
, enableBloat ? false
}:

# Note: when upgrading this package, please run the list-missing-tools.sh script as described below!
python3Packages.buildPythonApplication rec {
  pname = "diffoscope";
  version = "183";

  src = fetchurl {
    url = "https://diffoscope.org/archive/diffoscope-${version}.tar.bz2";
    sha256 = "sha256-XFFrRmCpE2UvZRCELfPaotLklyjLiCDWkyFWkISOHZM=";
  };

  outputs = [ "out" "man" ];

  patches = [
    ./ignore_links.patch
  ];

  postPatch = ''
    # Upstream doesn't provide a PKG-INFO file
    sed -i setup.py -e "/'rpm-python',/d"

    # When generating manpage, use the installed version
    substituteInPlace doc/Makefile --replace "../bin" "$out/bin"
  '';

  nativeBuildInputs = [ docutils help2man installShellFiles ];

  # Most of the non-Python dependencies here are optional command-line tools for various file-format parsers.
  # To help figuring out what's missing from the list, run: ./pkgs/tools/misc/diffoscope/list-missing-tools.sh
  #
  # Still missing these tools: docx2txt dumpimage dumppdf dumpxsb enjarify lipo ocamlobjinfo oggDump otool procyon
  pythonPath = [
      binutils-unwrapped bzip2 colordiff coreutils cpio db diffutils
      e2fsprogs file findutils fontforge-fonttools gettext gnutar gzip
      libarchive libcaca lz4 openssl pgpdump sng sqlite squashfsTools unzip xxd
      xz zip zstd
    ]
    ++ (with python3Packages; [
      argcomplete debian defusedxml jsondiff jsbeautifier libarchive-c
      python_magic progressbar33 pypdf2 rpm tlsh
    ])
    ++ lib.optionals stdenv.isLinux [ python3Packages.pyxattr acl cdrkit dtc ]
    ++ lib.optionals enableBloat ([
      abootimg apksigner apktool cbfstool colord ffmpeg fpc ghc ghostscriptX giflib gnupg gnumeric
      hdf5 imagemagick llvm jdk mono odt2txt openssh pdftk poppler_utils qemu R tcpdump wabt radare2
    ] ++ (with python3Packages; [ binwalk guestfs h5py ]));

  checkInputs = with python3Packages; [ pytestCheckHook ] ++ pythonPath;

  postInstall = ''
    make -C doc
    installManPage doc/diffoscope.1
  '';

  # Disable flaky test and a failing one
  disabledTests = [
    "test_android_manifest"
    "test_sbin_added_to_path"
    "test_diff_meta"
    "test_diff_meta2"
    "test_obj_no_differences"

    # Failing because of file-v5.40 has a slightly different output.
    # Upstream issue: https://salsa.debian.org/reproducible-builds/diffoscope/-/issues/271
    "test_text_proper_indentation"
  ] ++ lib.optionals stdenv.isDarwin [
    # Disable flaky tests on Darwin
    "test_non_unicode_filename"
    "test_listing"
  ];

  # flaky tests on Darwin
  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "tests/comparators/test_git.py"
    "tests/comparators/test_java.py"
    "tests/comparators/test_uimage.py"
    "tests/comparators/test_device.py"
    "tests/comparators/test_macho.py"
  ];

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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dezgeg ma27 danielfullmer ];
    platforms = platforms.unix;
  };
}
