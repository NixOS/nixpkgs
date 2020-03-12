{ stdenv, python3, acl, libb2, lz4, zstd, openssl, openssh }:

python3.pkgs.buildPythonApplication rec {
  pname = "borgbackup";
  version = "1.1.11";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "190gjzx83b6p64nqj840x382dgz9gfv0gm7wj585lnkrpa90j29n";
  };

  nativeBuildInputs = with python3.pkgs; [
    # For building documentation:
    sphinx guzzle_sphinx_theme
  ];
  buildInputs = [
    libb2 lz4 zstd openssl python3.pkgs.setuptools_scm
  ] ++ stdenv.lib.optionals stdenv.isLinux [ acl ];
  propagatedBuildInputs = with python3.pkgs; [
    cython llfuse
  ];

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

  checkInputs = with python3.pkgs; [
    pytest
  ];

  checkPhase = ''
    HOME=$(mktemp -d) py.test --pyargs borg.testsuite
  '';

  # 64 failures, needs pytest-benchmark
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A deduplicating backup program (attic fork)";
    homepage = https://www.borgbackup.org;
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
    maintainers = with maintainers; [ flokli dotlambda globin ];
  };
}
