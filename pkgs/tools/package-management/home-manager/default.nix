#Taken directly from
#https://github.com/rycee/home-manager/blob/9c1b3735b402346533449efc741f191d6ef578dd/home-manager/default.nix

{ bash, coreutils, less, stdenv, makeWrapper, fetchFromGitHub

  # Extra path to the Home Manager modules. If set then this path will
  # be tried before `$HOME/.config/nixpkgs/home-manager/modules` and
  # `$HOME/.nixpkgs/home-manager/modules`.
}:

stdenv.mkDerivation rec {
  name = "home-manager-${version}";
  version = "2017-12-7";
  src = fetchFromGitHub{
    owner = "rycee";
    repo = "home-manager";
    rev = "0be32c9d42e3a8739263ae7886dc2448c833c19c";
    sha256 = "06lmnzlf5fmiicbgai27ad9m3bj980xf8ifdpc5lzbsy77pfcfap";
  };
  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = let
    dot = "${src}/home-manager/home-manager" ;

  in ''
    install -v -D -m755 ${dot} $out/bin/home-manager

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
