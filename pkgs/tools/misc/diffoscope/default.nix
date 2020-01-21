{ lib, stdenv, fetchurl, python3Packages, docutils, help2man
, acl, apktool, binutils-unwrapped, bzip2, cbfstool, cdrkit, colord, colordiff, coreutils, cpio, db, diffutils, dtc
, e2fsprogs, file, findutils, fontforge-fonttools, fpc, gettext, ghc, ghostscriptX, giflib, gnumeric, gnupg, gnutar
, gzip, imagemagick, jdk, libarchive, libcaca, llvm, lz4, mono, openssh, pdftk, pgpdump, poppler_utils, sng, sqlite
, squashfsTools, tcpdump, unoconv, unzip, xxd, xz
, enableBloat ? false
}:

# Note: when upgrading this package, please run the list-missing-tools.sh script as described below!
python3Packages.buildPythonApplication rec {
  pname = "diffoscope";
  version = "133";

  src = fetchurl {
    url    = "https://diffoscope.org/archive/diffoscope-${version}.tar.bz2";
    sha256 = "15hi2fwcx3sf189rmxpyah0amq1a49wgp1ynhvwij5qj13wib2q8";
  };

  patches = [
    ./ignore_links.patch
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
  # Still missing these tools: abootimg docx2txt dumpxsb enjarify js-beautify lipo oggDump otool procyon-decompiler Rscript wasm2wat zipnode
  # Also these libraries: python3-guestfs
  pythonPath = [
      binutils-unwrapped bzip2 colordiff coreutils cpio db diffutils
      dtc e2fsprogs file findutils fontforge-fonttools gettext gnutar gzip
      libarchive libcaca lz4 pgpdump sng sqlite squashfsTools unzip xxd xz
    ]
    ++ (with python3Packages; [ debian libarchive-c python_magic tlsh rpm progressbar33 ])
    ++ lib.optionals stdenv.isLinux [ python3Packages.pyxattr acl cdrkit ]
    ++ lib.optionals enableBloat [
      apktool cbfstool colord fpc ghc ghostscriptX giflib gnupg gnumeric imagemagick
      llvm jdk mono openssh pdftk poppler_utils tcpdump unoconv
      python3Packages.guestfs
    ];

  doCheck = false; # Calls 'mknod' in squashfs tests, which needs root
  checkInputs = with python3Packages; [ pytest ];

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
    homepage    = https://wiki.debian.org/ReproducibleBuilds;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ dezgeg ];
    platforms   = platforms.unix;
  };
}
