{ stdenv, python3Packages, acl, lz4, openssl, openssh }:

python3Packages.buildPythonApplication rec {
  pname = "borgbackup";
  version = "1.1.5";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "4356e6c712871f389e3cb1d6382e341ea635f9e5c65de1cd8fcd103d0fb66d3d";
  };

  postPatch = ''
    # loosen constraint on msgpack version, only 0.5.0 had problems
    sed -i "s/'msgpack-python.*'/'msgpack-python'/g" setup.py
  '';

  nativeBuildInputs = with python3Packages; [
    # For building documentation:
    sphinx guzzle_sphinx_theme
  ];
  buildInputs = [
    lz4 openssl python3Packages.setuptools_scm
  ] ++ stdenv.lib.optionals stdenv.isLinux [ acl ];
  propagatedBuildInputs = with python3Packages; [
    cython msgpack-python
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

  meta = with stdenv.lib; {
    description = "A deduplicating backup program (attic fork)";
    homepage = https://borgbackup.github.io/;
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
    maintainers = with maintainers; [ flokli ];
  };
}
