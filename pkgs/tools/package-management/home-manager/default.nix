#Adapted from
#https://github.com/rycee/home-manager/blob/9c1b3735b402346533449efc741f191d6ef578dd/home-manager/default.nix

{ bash, coreutils, less, stdenv, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "home-manager-${version}";
  version = "2019-04-23";

  src = fetchFromGitHub {
    owner = "rycee";
    repo = "home-manager";
    rev = "ba0375bf06e0e0c3b2377edf913b7fddfd5a0b40";
    sha256 = "1ksr8fw5p5ai2a02whppc0kz9b3m5363hvfjghkzkd623kfh9073";
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
