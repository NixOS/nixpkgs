{ lib, stdenv, fetchgit, fetchpatch, pythonPackages, docutils
, acl, binutils, bzip2, cbfstool, cdrkit, colord, cpio, diffutils, e2fsprogs, file, fpc, gettext, ghc
, gnupg1, gzip, jdk, libcaca, mono, pdftk, poppler_utils, rpm, sng, sqlite, squashfsTools, unzip, vim, xz
, colordiff
, enableBloat ? false
}:

pythonPackages.buildPythonApplication rec {
  name = "diffoscope-${version}";
  version = "63";

  namePrefix = "";

  src = fetchgit {
    url = "git://anonscm.debian.org/reproducible/diffoscope.git";
    rev = "refs/tags/${version}";
    sha256 = "018c0xcgf6pgq493dib29pfyqpj7vb93a6qfmdh790fpxa2j1zyd";
  };

  patches =
    [ # Ignore different link counts.
      ./ignore_links.patch

      # Our Glibc doesn't have the C.UTF-8 locale yet
      # (https://sourceware.org/glibc/wiki/Proposals/C.UTF-8), so use
      # en_US.UTF-8 instead.
      ./locale.patch
    ];

  postPatch = ''
    # Upstream doesn't provide a PKG-INFO file
    sed -i setup.py -e "/'rpm-python',/d"
  '';

  # Still missing these tools: enjarify, otool & lipo (maybe OS X only), showttf
  # Also these libraries: python3-guestfs
  # FIXME: move xxd into a separate package so we don't have to pull in all of vim.
  propagatedBuildInputs = (with pythonPackages; [ debian libarchive-c python_magic tlsh ]) ++
    map lib.getBin ([ acl binutils bzip2 cbfstool cdrkit cpio diffutils e2fsprogs file gettext
      gzip libcaca poppler_utils rpm sng sqlite squashfsTools unzip vim xz colordiff
    ] ++ lib.optionals enableBloat [ colord fpc ghc gnupg1 jdk mono pdftk ]);

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
    homepage = https://wiki.debian.org/ReproducibleBuilds;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
