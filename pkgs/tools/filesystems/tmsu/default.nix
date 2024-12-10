{
  lib,
  buildGoPackage,
  fetchFromGitHub,
  installShellFiles,
}:

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

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    mv go/src/${goPackagePath} src
    mv src/src/${goPackagePath} go/src/${goPackagePath}
    export GOPATH=$PWD:$GOPATH
  '';

  postInstall = ''
    # can't do "mv TMSU tmsu" on case-insensitive filesystems
    mv $out/bin/{TMSU,tmsu.tmp}
    mv $out/bin/{tmsu.tmp,tmsu}

    cp src/misc/bin/* $out/bin/
    installManPage src/misc/man/tmsu.1
    installShellCompletion --zsh src/misc/zsh/_tmsu
  '';

  meta = with lib; {
    homepage = "http://www.tmsu.org";
    description = "A tool for tagging your files using a virtual filesystem";
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
