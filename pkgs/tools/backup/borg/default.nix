{ stdenv, python3Packages, acl, libb2, lz4, zstd, openssl, openssh }:

python3Packages.buildPythonApplication rec {
  pname = "borgbackup";
  version = "1.1.7";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "f7b51a132e9edfbe1cacb4f478b28caf3622d79fffcb369bdae9f92d8c8a7fdc";
  };

  nativeBuildInputs = with python3Packages; [
    # For building documentation:
    sphinx guzzle_sphinx_theme
  ];
  buildInputs = [
    libb2 lz4 zstd openssl python3Packages.setuptools_scm
  ] ++ stdenv.lib.optionals stdenv.isLinux [ acl ];
  propagatedBuildInputs = with python3Packages; [
    cython msgpack-python
  ] ++ stdenv.lib.optionals (!stdenv.isDarwin) [ llfuse ];

  preConfigure = ''
    export BORG_OPENSSL_PREFIX="${openssl.dev}"
    export BORG_LZ4_PREFIX="${lz4.dev}"
    export BORG_LIBB2_PREFIX="${libb2}"
    export BORG_LIBZSTD_PREFIX="${zstd}"
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

    mkdir -p $out/share/bash-completion/completions
    cp scripts/shell_completions/bash/borg $out/share/bash-completion/completions/

    mkdir -p $out/share/fish/vendor_completions.d
    cp scripts/shell_completions/fish/borg.fish $out/share/fish/vendor_completions.d/

    mkdir -p $out/share/zsh/site-functions
    cp scripts/shell_completions/zsh/_borg $out/share/zsh/site-functions/
  '';

  checkInputs = with python3Packages; [
    pytest
  ];

  checkPhase = ''
    HOME=$(mktemp -d) py.test --pyargs borg.testsuite
  '';

  # 63 failures, needs pytest-benchmark
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A deduplicating backup program (attic fork)";
    homepage = https://www.borgbackup.org;
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
    maintainers = with maintainers; [ flokli dotlambda ];
  };
}
