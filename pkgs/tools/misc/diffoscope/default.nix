{ lib, stdenv, fetchgit, fetchpatch, pythonPackages, docutils
, acl, binutils, bzip2, cbfstool, cdrkit, colord, cpio, diffutils, e2fsprogs, file, fpc, gettext, ghc
, gnupg1, gzip, jdk, libcaca, mono, pdftk, poppler_utils, rpm, sng, sqlite, squashfsTools, unzip, vim, xz
, enableBloat ? false
}:

pythonPackages.buildPythonApplication rec {
  name = "diffoscope-${version}";
  version = "49";

  namePrefix = "";

  src = fetchgit {
    url = "git://anonscm.debian.org/reproducible/diffoscope.git";
    rev = "refs/tags/${version}";
    sha256 = "0kh96h95rp7bk8rgc1z18jwv89dyp1n36bawqyqxhwwklmrgxr66";
  };

  patches =
    [ # Ignore different link counts and inode change times.
      (fetchpatch {
        url = https://github.com/edolstra/diffoscope/commit/367f77bba8df0dbc89e63c9f66f05736adf5ec59.patch;
        sha256 = "0mnp7icdrjn02dr6f5dwqvvr848jzgkv3cg69a24234y9gxd30ww";
      })
    ];

  postPatch = ''
    # Upstream doesn't provide a PKG-INFO file
    sed -i setup.py -e "/'rpm-python',/d"
  '';

  # Still missing these tools: enjarify, otool & lipo (maybe OS X only), showttf
  # Also these libraries: python3-guestfs
  # FIXME: move xxd into a separate package so we don't have to pull in all of vim.
  propagatedBuildInputs = (with pythonPackages; [ debian libarchive-c python_magic tlsh ]) ++
    [ acl binutils bzip2 cbfstool cdrkit cpio diffutils e2fsprogs file gettext
      gzip libcaca poppler_utils rpm sng sqlite squashfsTools unzip vim xz
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
    homepage = https://wiki.debian.org/ReproducibleBuilds;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
