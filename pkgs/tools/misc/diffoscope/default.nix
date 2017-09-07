{ lib, stdenv, fetchgit, fetchpatch, python3Packages, docutils
, acl, binutils, bzip2, cbfstool, cdrkit, colord, cpio, diffutils, e2fsprogs, file, fpc, gettext, ghc
, gnupg1, gzip, jdk, libcaca, mono, pdftk, poppler_utils, sng, sqlite, squashfsTools, unzip, xxd, xz
, colordiff
, enableBloat ? false
}:

python3Packages.buildPythonApplication rec {
  name = "diffoscope-${version}";
  version = "85";

  src = fetchgit {
    url    = "git://anonscm.debian.org/reproducible/diffoscope.git";
    rev    = "refs/tags/${version}";
    sha256 = "0kmcfhgva1fl6x5b07sc7k6ba9mqs3ma0lvspxm31w7nrrrqcvlr";
  };

  patches = [
    # Ignore different link counts - doesn't work with 85
    # ./ignore_links.patch
  ];

  postPatch = ''
    # Upstream doesn't provide a PKG-INFO file
    sed -i setup.py -e "/'rpm-python',/d"
  '';

  # Still missing these tools: enjarify, otool & lipo (maybe macOS only), showttf
  # Also these libraries: python3-guestfs
  pythonPath = with python3Packages;
    [ debian libarchive-c python_magic tlsh rpm cdrkit acl binutils bzip2 cbfstool cpio diffutils e2fsprogs file gettext
      gzip libcaca poppler_utils sng sqlite squashfsTools unzip xxd xz colordiff
    ] ++ lib.optionals enableBloat [ colord fpc ghc gnupg1 jdk mono pdftk ];

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
