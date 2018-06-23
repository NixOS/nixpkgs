#Adapted from
#https://github.com/rycee/home-manager/blob/9c1b3735b402346533449efc741f191d6ef578dd/home-manager/default.nix

{ bash, coreutils, less, stdenv, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "home-manager-${version}";
  version = "2018-06-14";

  src = fetchFromGitHub{
    owner = "rycee";
    repo = "home-manager";
    rev = "5641ee3f942e700de35b28fc879b0d8a10a7a1fe";
    sha256 = "0bqzwczbr5c2y3ms7m7ly0as9zsnqwljq61ci2y2gbqzw3md1x2j";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = ''
    install -v -D -m755 ${src}/home-manager/home-manager $out/bin/home-manager

    substituteInPlace $out/bin/home-manager \
      --subst-var-by bash "${bash}" \
      --subst-var-by coreutils "${coreutils}" \
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
