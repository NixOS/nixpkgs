#Adapted from
#https://github.com/rycee/home-manager/blob/2c07829be2bcae55e04997b19719ff902a44016d/home-manager/default.nix

{ bash, coreutils, findutils, gnused, less, stdenv, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {

  pname = "home-manager";
  version = "2020-09-06";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "home-manager";
    rev = "249650a07ee2d949fa599f3177a8c234adbd1bee";
    sha256 = "0x858b7i15kx74aqwgi2n5ls7zjhcky95z9vbxfdlawmaz371dma";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = ''
    install -v -D -m755 ${src}/home-manager/home-manager $out/bin/home-manager

    substituteInPlace $out/bin/home-manager \
      --subst-var-by bash "${bash}" \
      --subst-var-by coreutils "${coreutils}" \
      --subst-var-by findutils "${findutils}" \
      --subst-var-by gnused "${gnused}" \
      --subst-var-by less "${less}" \
      --subst-var-by HOME_MANAGER_PATH '${src}'

    install -D -m755 home-manager/completion.bash \
      "$out/share/bash-completion/completions/home-manager"
  '';

  meta = with stdenv.lib; {
    description = "A user environment configurator";
    homepage = "https://rycee.gitlab.io/home-manager/";
    platforms = platforms.unix;
    license = licenses.mit;
  };

}
