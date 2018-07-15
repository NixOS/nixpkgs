{ lib, stdenv, fetchgit, python3Packages, docutils, help2man
, acl, apktool, binutils-unwrapped, bzip2, cbfstool, cdrkit, colord, colordiff, coreutils, cpio, db, diffutils, dtc
, e2fsprogs, file, findutils, fontforge-fonttools, fpc, gettext, ghc, ghostscriptX, giflib, gnupg1, gnutar
, gzip, imagemagick, jdk, libarchive, libcaca, llvm, mono, openssh, pdftk, pgpdump, poppler_utils, sng, sqlite
, squashfsTools, tcpdump, unoconv, unzip, xxd, xz
, enableBloat ? false
}:

python3Packages.buildPythonApplication rec {
  name = "diffoscope-${version}";
  version = "98";

  src = fetchgit {
    url    = "https://anonscm.debian.org/git/reproducible/diffoscope.git";
    rev    = "refs/tags/${version}";
    sha256 = "1xvalxz11jlyk9aczq5g367ldx0wfib4kpxs8f1rg7kh97r8z1rh";
  };

  patches = [
    ./ignore_links.patch
  ];

  postPatch = ''
    # Upstream doesn't provide a PKG-INFO file
    sed -i setup.py -e "/'rpm-python',/d"
  '';

  nativeBuildInputs = [ docutils help2man ];

  # Still missing these tools: abootimg docx2txt dumpxsb enjarify js-beautify lipo oggDump otool procyon-decompiler Rscript
  # Also these libraries: python3-guestfs
  pythonPath = with python3Packages; [ debian libarchive-c python_magic tlsh rpm ] ++ [
      acl binutils-unwrapped bzip2 cdrkit colordiff coreutils cpio db diffutils
      dtc e2fsprogs file findutils fontforge-fonttools gettext gnutar gzip
      libarchive libcaca pgpdump progressbar33 sng sqlite squashfsTools unzip xxd xz
    ] ++ lib.optionals enableBloat [
      apktool cbfstool colord fpc ghc ghostscriptX giflib gnupg1 imagemagick
      llvm jdk mono openssh pdftk poppler_utils tcpdump unoconv
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
    platforms   = platforms.linux;
  };
}
