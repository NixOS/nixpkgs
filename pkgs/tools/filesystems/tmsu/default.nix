{ stdenv, buildGoPackage, fetchFromGitHub, fuse, installShellFiles }:

buildGoPackage rec {
  pname = "tmsu";
  version = "0.7.5";
  goPackagePath = "github.com/oniony/TMSU";

  src = fetchFromGitHub {
    owner = "oniony";
    repo = "tmsu";
    rev = "v${version}";
    sha256 = "0834hah7p6ad81w60ifnxyh9zn09ddfgrll04kwjxwp7ypbv38wq";
  };

  goDeps = ./deps.nix;

  buildInputs = [ fuse ];
  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    mv go/src/${goPackagePath} src
    mv src/src/${goPackagePath} go/src/${goPackagePath}
    export GOPATH=$PWD:$GOPATH
  '';

  postInstall = ''
    mv $out/bin/{TMSU,tmsu}
    cp src/misc/bin/* $out/bin/
    installManPage src/misc/man/tmsu.1
    installShellCompletion --zsh src/misc/zsh/_tmsu
  '';

  meta = with stdenv.lib; {
    homepage    = "http://www.tmsu.org";
    description = "A tool for tagging your files using a virtual filesystem";
    maintainers = with maintainers; [ pSub ];
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };
}
