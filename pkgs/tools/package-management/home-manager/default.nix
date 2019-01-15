#Adapted from
#https://github.com/rycee/home-manager/blob/9c1b3735b402346533449efc741f191d6ef578dd/home-manager/default.nix

{ bash, coreutils, less, stdenv, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "home-manager-${version}";
  version = "2018-11-04";

  src = fetchFromGitHub {
    owner = "rycee";
    repo = "home-manager";
    rev = "05c93ff3ae13f1a2d90a279a890534cda7dc8ad6";
    sha256 = "0ymfvjnnz98ynws3v6dcil1cmp7x2cmm6zy8yqgkn8z7wyrrqq0v";
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
