#Adapted from
#https://github.com/rycee/home-manager/blob/2c07829be2bcae55e04997b19719ff902a44016d/home-manager/default.nix

{ bash, coreutils, findutils, gnused, less, stdenv, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {

  pname = "home-manager";
  version = "2019-09-04";

  src = fetchFromGitHub {
    owner = "rycee";
    repo = "home-manager";
    rev = "1923ac3358cbd2d75352c2db2178314eb4623818";
    sha256 = "1xdsz62sjh8j3p8jfz449gv9vl01adk3qdyjvbpgi7y5c09ymwg7";
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
