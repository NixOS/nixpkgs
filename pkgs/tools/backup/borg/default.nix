{ stdenv, fetchurl, python3Packages, acl, lz4, openssl }:

python3Packages.buildPythonApplication rec {
  name = "borgbackup-${version}";
  version = "1.1.0";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/borgbackup/borg/releases/download/"
      + "${version}/${name}.tar.gz";
    sha256 = "0vwyg0b4kxb0rspqwhvgi5c78dzimgkydf03wif27a40qhh1235l";
  };

  nativeBuildInputs = with python3Packages; [
    # For building documentation:
    sphinx guzzle_sphinx_theme
  ];
  buildInputs = [
    acl lz4 openssl python3Packages.setuptools_scm
  ];
  propagatedBuildInputs = with python3Packages; [
    cython llfuse msgpack
  ];

  preConfigure = ''
    export BORG_OPENSSL_PREFIX="${openssl.dev}"
    export BORG_LZ4_PREFIX="${lz4.dev}"
  '';

  postInstall = ''
    make -C docs singlehtml
    mkdir -p $out/share/doc/borg
    cp -R docs/_build/singlehtml $out/share/doc/borg/html

    make -C docs man
    mkdir -p $out/share/man
    cp -R docs/_build/man $out/share/man/man1
  '';

  # tests fail due to missing test command in nix_run_setup.py
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A deduplicating backup program (attic fork)";
    homepage = https://borgbackup.github.io/;
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
    maintainers = with maintainers; [ nckx ];
  };
}
