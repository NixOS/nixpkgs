{ stdenv, fetchgit, fetchFromGitHub, go, fuse }:

stdenv.mkDerivation rec {
  name = "tmsu-${version}";
  version = "0.6.1";

  go-sqlite3 = fetchgit {
    url = "git://github.com/mattn/go-sqlite3";
    rev = "c9a0db5d8951646743317f0756da0339fe144dd5";
    sha256 = "1m0q9869fis0dhg34g5wc5xi6pby491spfxi23w461h29higbrqh";
  };

  go-fuse = fetchgit {
    url = "git://github.com/hanwen/go-fuse";
    rev = "8c85ded140ac1889372a0e22d8d21e3d10a303bd";
    sha256 = "1iph2hpvby2mfwqg9pp39xjqdl9a09h4442yfdn5l67pznljh2bi";
  };

  src = fetchFromGitHub {
    owner = "oniony";
    repo = "tmsu";
    rev = "v${version}";
    sha256 = "08mz08pw59zaljp7dcndklnfdbn36ld27capivq3ifbq96nnqdf3";
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
