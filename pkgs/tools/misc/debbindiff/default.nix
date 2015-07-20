{ stdenv, fetchgit, pythonPackages, docutils
, acl, binutils, bzip2, cdrkit, cpio, diffutils, e2fsprogs, file, gettext
, gnupg, gzip, pdftk, poppler_utils, rpm, squashfsTools, unzip, vim, xz
}:

pythonPackages.buildPythonPackage rec {
  name = "debbindiff-${version}";
  version = "26";

  namePrefix = "";

  src = fetchgit {
    url = "git://anonscm.debian.org/reproducible/debbindiff.git";
    rev = "refs/tags/${version}";
    sha256 = "18637gc7c92mwcpx3dvh6xild0sb9bwsgfcrjplmh7s8frvlvkv6";
  };

  postPatch = ''
    # Different pkg name in debian
    sed -i setup.py -e "s@'magic'@'Magic-file-extensions'@"

    # Upstream doesn't provide a PKG-INFO file
    sed -i setup.py -e "/'rpm',/d"
  '';

  # Still missing these tools: ghc javap showttf sng
  propagatedBuildInputs = (with pythonPackages; [ debian magic ]) ++
    [ acl binutils bzip2 cdrkit cpio diffutils e2fsprogs file gettext gnupg
      gzip pdftk poppler_utils rpm squashfsTools unzip vim xz ];

  doCheck = false; # Calls 'mknod' in squashfs tests, which needs root

  postInstall = ''
    mv $out/bin/debbindiff.py $out/bin/debbindiff
    mkdir -p $out/share/man/man1
    ${docutils}/bin/rst2man.py debian/debbindiff.1.rst $out/share/man/man1/debbindiff.1
  '';

  meta = with stdenv.lib; {
    description = "Highlight differences between two builds of Debian packages, and even other kind of files";
    homepage = https://wiki.debian.org/ReproducibleBuilds;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
