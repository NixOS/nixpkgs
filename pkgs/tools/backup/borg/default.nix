{ stdenv, fetchpatch, python3, acl, libb2, lz4, zstd, openssl, openssh }:

let
  python = python3.override {
    packageOverrides = self: super: {
      # https://github.com/borgbackup/borg/issues/3753#issuecomment-454011810
      msgpack-python = super.msgpack-python.overridePythonAttrs (oldAttrs: rec {
        version = "0.5.6";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0ee8c8c85aa651be3aa0cd005b5931769eaa658c948ce79428766f1bd46ae2c3";
        };
      });
    };
  };

in python.pkgs.buildPythonApplication rec {
  pname = "borgbackup";
  version = "1.1.9";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "7d0ff84e64c4be35c43ae2c047bb521a94f15b278c2fe63b43950c4836b42575";
  };

  nativeBuildInputs = with python.pkgs; [
    # For building documentation:
    sphinx guzzle_sphinx_theme
  ];
  buildInputs = [
    libb2 lz4 zstd openssl python.pkgs.setuptools_scm
  ] ++ stdenv.lib.optionals stdenv.isLinux [ acl ];
  propagatedBuildInputs = with python.pkgs; [
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

  checkInputs = with python.pkgs; [
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
