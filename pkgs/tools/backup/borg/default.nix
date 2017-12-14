{ stdenv, fetchurl, python3Packages, acl, lz4, openssl, openssh }:

python3Packages.buildPythonApplication rec {
  name = "borgbackup-${version}";
  version = "1.1.3";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/borgbackup/borg/releases/download/"
      + "${version}/${name}.tar.gz";
    sha256 = "1rvn8b6clzd1r317r9jkvk34r31risi0dxfjc7jffhnwasck4anc";
  };

  nativeBuildInputs = with python3Packages; [
    # For building documentation:
    sphinx guzzle_sphinx_theme
  ];
  buildInputs = [
    lz4 openssl python3Packages.setuptools_scm
  ] ++ stdenv.lib.optionals stdenv.isLinux [ acl ];
  propagatedBuildInputs = with python3Packages; [
    cython msgpack
  ] ++ stdenv.lib.optionals (!stdenv.isDarwin) [ llfuse ];

  preConfigure = ''
    export BORG_OPENSSL_PREFIX="${openssl.dev}"
    export BORG_LZ4_PREFIX="${lz4.dev}"
  '';

  makeWrapperArgs = [
    ''--prefix PATH ':' "${openssh}/bin"''
  ];

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
    maintainers = with maintainers; [ nckx flokli ];
  };
}
