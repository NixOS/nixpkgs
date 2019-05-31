#Adapted from
#https://github.com/rycee/home-manager/blob/2c07829be2bcae55e04997b19719ff902a44016d/home-manager/default.nix

{ bash, coreutils, findutils, gnused, less, stdenv, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "home-manager-${version}";
  version = "2019-05-24";

  src = fetchFromGitHub {
    owner = "rycee";
    repo = "home-manager";
    rev = "d726afd9e45246fe68cfff0af80600ea26bd79fe";
    sha256 = "1pwq475s6bbzhqbdx5v68gnlh02654r7apskl1s9lpxb9s5rg0hf";
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
  '';

  meta = with stdenv.lib; {
    description = "A user environment configurator";
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.linux;
    license = licenses.mit;
  };

}
