#Adapted from
#https://github.com/rycee/home-manager/blob/2c07829be2bcae55e04997b19719ff902a44016d/home-manager/default.nix

{ bash, coreutils, findutils, gnused, less, lib, stdenv, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {

  pname = "home-manager";
  version = "2021-01-16";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "home-manager";
    rev = "8127799f79ee96129b295d78294f40a54078131f";
    sha256 = "0iji8nxa66s409pvjwi370ycsw4m74w6b3ywnjpfkl2filpapjns";
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
