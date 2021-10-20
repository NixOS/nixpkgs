#Adapted from
#https://github.com/rycee/home-manager/blob/2c07829be2bcae55e04997b19719ff902a44016d/home-manager/default.nix

{ bash, coreutils, findutils, gnused, less, lib, stdenv, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {

  pname = "home-manager";
  version = "2021-03-21";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "home-manager";
    rev = "ddcd476603dfd3388b1dc8234fa9d550156a51f5";
    sha256 = "sha256-E6ABXtzw6bHmrIirB1sJL6S2MEa3sfcvRLzRa92frCo=";
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

  meta = with lib; {
    description = "A user environment configurator";
    homepage = "https://rycee.gitlab.io/home-manager/";
    platforms = platforms.unix;
    license = licenses.mit;
  };

}
