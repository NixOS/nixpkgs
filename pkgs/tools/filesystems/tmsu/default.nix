{ stdenv, fetchgit, fetchFromGitHub, go, fuse }:

stdenv.mkDerivation rec {
  name = "tmsu-${version}";
  version = "0.6.0";

  go-sqlite3 = fetchgit {
    url = "git://github.com/mattn/go-sqlite3";
    rev = "c9a0db5d8951646743317f0756da0339fe144dd5";
    sha256 = "0j01nr3q89qs9n9zzp8gsr94hl9v0gnis6hmndl9ms554bhlv99p";
  };

  go-fuse = fetchgit {
    url = "git://github.com/hanwen/go-fuse";
    rev = "8c85ded140ac1889372a0e22d8d21e3d10a303bd";
    sha256 = "1kssndvrbcxvf85x6c6lgn5kpcl7d788z3sxrv1szik4acb6n2sa";
  };

  src = fetchFromGitHub {
    owner = "oniony";
    repo = "tmsu";
    rev = "v${version}";
    sha256 = "1fqq8cj1awwhb076s88l489kj664ndc343gqi8c21yp9wj6fzpnq";
  };

  buildInputs = [ go fuse ];

  preBuild = ''
    mkdir -p src/github.com/mattn/go-sqlite3/
    ln -s ${go-sqlite3}/* src/github.com/mattn/go-sqlite3

    mkdir -p src/github.com/hanwen/go-fuse
    ln -s ${go-fuse}/* src/github.com/hanwen/go-fuse

    mkdir -p src/github.com/oniony/tmsu
    ln -s ${src}/* src/github.com/oniony/tmsu

    patchShebangs tests/.

    export GOPATH=$PWD
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/sbin
    mkdir -p $out/share/man
    mkdir -p $out/share/zsh/site-functions
    make install INSTALL_DIR=$out/bin \
                 MOUNT_INSTALL_DIR=$out/sbin \
                 MAN_INSTALL_DIR=$out/share/man \
                 ZSH_COMP_INSTALL_DIR=$out/share/zsh/site-functions
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.tmsu.org;
    description = "A tool for tagging your files using a virtual filesystem";
    maintainers = with maintainers; [ pSub ];
    license     = licenses.gpl3;
    platforms   = platforms.all;
  };
}
