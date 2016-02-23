{ stdenv, fetchurl, python3Packages, acl, lz4, openssl }:

python3Packages.buildPythonApplication rec {
  name = "borgbackup-${version}";
  version = "0.30.0";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/b/borgbackup/borgbackup-${version}.tar.gz";
    sha256 = "0n78c982kdfqbyi9jawcvzgdik4l36c2s7rpzkfr1ka6506k2rx4";
  };

  nativeBuildInputs = with python3Packages; [
    # For building documentation:
    sphinx
  ];
  propagatedBuildInputs = [
    acl lz4 openssl
  ] ++ (with python3Packages; [
    cython msgpack llfuse tox detox setuptools_scm
  ]);

  preConfigure = ''
    export BORG_OPENSSL_PREFIX="${openssl}"
    export BORG_LZ4_PREFIX="${lz4}"
  '';

  postInstall = ''
    make -C docs singlehtml
    mkdir -p $out/share/doc/borg
    cp -R docs/_build/singlehtml $out/share/doc/borg/html

    make -C docs man
    mkdir -p $out/share/man
    cp -R docs/_build/man $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "A deduplicating backup program (attic fork)";
    homepage = https://borgbackup.github.io/;
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
    maintainers = with maintainers; [ nckx ];
  };
}
