{ stdenv, lib, fetchFromGitHub, buildGoPackage }:

with lib;

buildGoPackage rec {
  pname = "zsh-history";
  version = "2019-08-29";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = "history";
    rev = "108698699b5fa03faec1bba1bdf7b8d1204535e6";
    sha256 = "0c11m7nkxc904zl3qf07h2an1dis6iizrvyfnhp1nslnmjrkida4";
  };

  goDeps = ./deps.nix;
  goPackagePath = "history";

  preConfigure = ''
    # Extract the source
    mkdir -p "$NIX_BUILD_TOP/go/src/github.com/b4b4r07"
    cp -a $NIX_BUILD_TOP/source "$NIX_BUILD_TOP/go/src/github.com/b4b4r07/history"
    export GOPATH=$NIX_BUILD_TOP/go/src/github.com/b4b4r07/history:$GOPATH
  '';

  installPhase = ''
    install -d "$bin/bin"
    install -m 0755 $NIX_BUILD_TOP/go/bin/history "$bin/bin"
    install -d $out/share
    cp -r $NIX_BUILD_TOP/go/src/history/misc/* $out/share
    cp -r $out/share/zsh/completions $out/share/zsh/site-functions
  '';

  meta = {
    description = "A CLI to provide enhanced history for your shell";
    license = licenses.mit;
    homepage = https://github.com/b4b4r07/history;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kampka ];
    outputsToInstall = [ "out" "bin" ];
  };
}
