{ lib, stdenv, fetchurl, python3Packages, docutils, help2man, installShellFiles
, abootimg, acl, apksigcopier, apksigner, apktool, binutils-unwrapped-all-targets, bzip2, cbfstool, cdrkit, colord, colordiff, coreutils, cpio, db, diffutils, dtc
, e2fsprogs, enjarify, file, findutils, fontforge-fonttools, ffmpeg, fpc, gettext, ghc, ghostscriptX, giflib, gnumeric, gnupg, gnutar
, gzip, html2text, hdf5, imagemagick, jdk, libarchive, libcaca, llvm, lz4, mono, ocaml, oggvideotools, openssh, openssl, pdftk, pgpdump, poppler_utils, procyon, qemu, R
, radare2, sng, sqlite, squashfsTools, tcpdump, ubootTools, odt2txt, unzip, wabt, xmlbeans, xxd, xz, zip, zstd
, enableBloat ? false
# updater only
, writeScript
}:

# Note: when upgrading this package, please run the list-missing-tools.sh script as described below!
python3Packages.buildPythonApplication rec {
  pname = "diffoscope";
  version = "229";

  src = fetchurl {
    url = "https://diffoscope.org/archive/diffoscope-${version}.tar.bz2";
    sha256 = "sha256-IyTBwlVqOIXERdjvZPTwxhIBPOn8Dt7QbvfBazj5J/A=";
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
  # Still missing these tools: docx2txt lipo otool r2pipe
  pythonPath = [
      binutils-unwrapped-all-targets bzip2 colordiff coreutils cpio db diffutils
      e2fsprogs file findutils fontforge-fonttools gettext gnutar gzip
      html2text libarchive lz4 openssl pgpdump sng sqlite squashfsTools unzip xxd
      xz zip zstd
    ]
    ++ (with python3Packages; [
      argcomplete debian defusedxml jsondiff jsbeautifier libarchive-c
      python-magic progressbar33 pypdf2 tlsh
    ])
    ++ lib.optionals stdenv.isLinux [ python3Packages.pyxattr python3Packages.rpm acl cdrkit dtc ]
    ++ lib.optionals enableBloat ([
      abootimg apksigcopier apksigner apktool cbfstool colord enjarify ffmpeg fpc ghc ghostscriptX giflib gnupg gnumeric
      hdf5 imagemagick libcaca llvm jdk mono ocaml odt2txt oggvideotools openssh pdftk poppler_utils procyon qemu R tcpdump ubootTools wabt radare2 xmlbeans
    ] ++ (with python3Packages; [ androguard binwalk guestfs h5py pdfminer-six ]));

  checkInputs = with python3Packages; [ pytestCheckHook ] ++ pythonPath;

  postInstall = ''
    make -C doc
    installManPage doc/diffoscope.1
  '';

  disabledTests = [
    "test_sbin_added_to_path"
    "test_diff_meta"
    "test_diff_meta2"

    # fails because it fails to determine llvm version
    "test_item3_deflate_llvm_bitcode"
  ] ++ lib.optionals stdenv.isDarwin [
    # Disable flaky tests on Darwin
    "test_non_unicode_filename"
    "test_listing"
    "test_symlink_root"
  ];

  # flaky tests on Darwin
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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dezgeg danielfullmer ];
    platforms = platforms.unix;
  };
}
