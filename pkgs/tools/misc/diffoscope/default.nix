{ lib, stdenv, fetchgit, python3Packages, docutils
, acl, binutils, bzip2, cbfstool, cdrkit, colord, colordiff, coreutils, cpio, diffutils, dtc, e2fsprogs
, file, findutils, fpc, gettext, ghc, gnupg1, gnutar, gzip, imagemagick, jdk, libarchive, libcaca, llvm
, mono, openssh, pdftk, poppler_utils, sng, sqlite, squashfsTools, tcpdump, unzip, xxd, xz
, enableBloat ? false
}:

python3Packages.buildPythonApplication rec {
  name = "diffoscope-${version}";
  version = "86";

  src = fetchgit {
    url    = "git://anonscm.debian.org/reproducible/diffoscope.git";
    rev    = "refs/tags/${version}";
    sha256 = "0jj3gn7pw7him12bxf0wbs6wkz32ydv909v5gi681p0dyzajd0zr";
  };

  patches = [
    ./ignore_links.patch
  ];

  postPatch = ''
    # Upstream doesn't provide a PKG-INFO file
    sed -i setup.py -e "/'rpm-python',/d"
  '';

  # Still missing these tools: apktool docx2txt enjarify gifbuild js-beautify odt2txt oggDump pgpdump ps2ascii Rscript showttf
  # Also these libraries: python3-guestfs
  pythonPath = with python3Packages; [ debian libarchive-c python_magic tlsh rpm ] ++ [
      acl binutils bzip2 cbfstool cdrkit colordiff coreutils cpio diffutils dtc e2fsprogs file
      findutils gettext gnutar gzip libarchive libcaca poppler_utils sng sqlite squashfsTools unzip
      xxd xz
    ] ++ lib.optionals enableBloat [ colord fpc ghc gnupg1 imagemagick llvm jdk mono openssh pdftk tcpdump ];

  doCheck = false; # Calls 'mknod' in squashfs tests, which needs root

  postInstall = ''
    mkdir -p $out/share/man/man1
    ${docutils}/bin/rst2man.py debian/diffoscope.1.rst $out/share/man/man1/diffoscope.1
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
