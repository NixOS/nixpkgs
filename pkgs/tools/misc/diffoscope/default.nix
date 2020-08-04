{ lib, stdenv, fetchurl, runCommand, makeWrapper, python3Packages, docutils, help2man
, abootimg, acl, apktool, binutils-unwrapped, build-tools, bzip2, cbfstool, cdrkit, colord, colordiff, coreutils, cpio, db, diffutils, dtc
, e2fsprogs, file, findutils, fontforge-fonttools, ffmpeg, fpc, gettext, ghc, ghostscriptX, giflib, gnumeric, gnupg, gnutar
, gzip, hdf5, imagemagick, jdk, libarchive, libcaca, llvm, lz4, mono, openssh, openssl, pdftk, pgpdump, poppler_utils, qemu, R
, sng, sqlite, squashfsTools, tcpdump, odt2txt, unzip, wabt, xxd, xz, zip, zstd
, enableBloat ? false
}:

# Note: when upgrading this package, please run the list-missing-tools.sh script as described below!
let
  apksigner = runCommand "apksigner" { nativeBuildInputs = [ makeWrapper ]; } ''
    mkdir -p $out/bin
    makeWrapper "${jdk}/bin/java" "$out/bin/apksigner" \
      --add-flags "-jar ${builtins.head build-tools}/libexec/android-sdk/build-tools/28.0.3/lib/apksigner.jar"
  '';
in
python3Packages.buildPythonApplication rec {
  pname = "diffoscope";
  version = "154";

  src = fetchurl {
    url    = "https://diffoscope.org/archive/diffoscope-${version}.tar.bz2";
    sha256 = "1l39ayshl29fl54skcrwc6a412np4ki25h1zj2n9lhir3g1v4rxs";
  };

  outputs = [ "out" "man" ];

  patches = [
    ./ignore_links.patch
    ./skip-failing-test.patch
  ];

  postPatch = ''
    # Upstream doesn't provide a PKG-INFO file
    sed -i setup.py -e "/'rpm-python',/d"

    # When generating manpage, use the installed version
    substituteInPlace doc/Makefile --replace "../bin" "$out/bin"
  '';

  nativeBuildInputs = [ docutils help2man ];

  # Most of the non-Python dependencies here are optional command-line tools for various file-format parsers.
  # To help figuring out what's missing from the list, run: ./pkgs/tools/misc/diffoscope/list-missing-tools.sh
  #
  # Still missing these tools: docx2txt dumppdf dumpxsb enjarify lipo ocamlobjinfo oggDump otool procyon
  pythonPath = [
      binutils-unwrapped bzip2 colordiff coreutils cpio db diffutils
      dtc e2fsprogs file findutils fontforge-fonttools gettext gnutar gzip
      libarchive libcaca lz4 openssl pgpdump sng sqlite squashfsTools unzip xxd
      xz zip zstd
    ]
    ++ (with python3Packages; [
      argcomplete debian defusedxml jsondiff jsbeautifier libarchive-c
      python_magic progressbar33 pypdf2 rpm tlsh
    ])
    ++ lib.optionals stdenv.isLinux [ python3Packages.pyxattr acl cdrkit ]
    ++ lib.optionals enableBloat ([
      abootimg apksigner apktool cbfstool colord ffmpeg fpc ghc ghostscriptX giflib gnupg gnumeric
      hdf5 imagemagick llvm jdk mono odt2txt openssh pdftk poppler_utils qemu R tcpdump wabt
    ] ++ (with python3Packages; [ binwalk guestfs h5py ]));

  checkInputs = with python3Packages; [ pytest ] ++ pythonPath;

  postInstall = ''
    make -C doc
    mkdir -p $out/share/man/man1
    cp doc/diffoscope.1 $out/share/man/man1/diffoscope.1
  '';

  meta = with stdenv.lib; {
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
    homepage    = "https://diffoscope.org/";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ dezgeg ma27 danielfullmer ];
    platforms   = platforms.unix;
  };
}
