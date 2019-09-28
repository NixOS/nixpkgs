{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "zsh-history";
  version = "2019-10-27";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = "history";
    rev = "527e6f51873992fbf9c1aad70aa3009a0027a8de";
    sha256 = "12dc380zfg3b9k7rcsyzi9dxqh28c4957b3fsx1nxvqvdm3ralm2";
  };

  goDeps = ./deps.nix;
  goPackagePath = "github.com/b4b4r07/history";

  postInstall = ''
    install -d $out/share
    cp -r $NIX_BUILD_TOP/go/src/${goPackagePath}/misc/* $out/share
    cp -r $out/share/zsh/completions $out/share/zsh/site-functions
  '';

  meta = with lib; {
    description = "A CLI to provide enhanced history for your shell";
    license = licenses.mit;
    homepage = https://github.com/b4b4r07/history;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kampka ];
  };
}
