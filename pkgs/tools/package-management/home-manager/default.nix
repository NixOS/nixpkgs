#Taken directly from
#https://github.com/rycee/home-manager/blob/9c1b3735b402346533449efc741f191d6ef578dd/home-manager/default.nix

{ bash, coreutils, less, stdenv, makeWrapper, fetchFromGitHub

  # Extra path to the Home Manager modules. If set then this path will
  # be tried before `$HOME/.config/nixpkgs/home-manager/modules` and
  # `$HOME/.nixpkgs/home-manager/modules`.
, modulesPath ? null
  # Extra path to Home Manager. If set then this path will be tried
  # before `$HOME/.config/nixpkgs/home-manager` and
  # `$HOME/.nixpkgs/home-manager`.
}:

stdenv.mkDerivation rec {
  name = "home-manager-${version}";
  version = "2017-11-22";
  src = fetchFromGitHub{
    owner = "rycee";
    repo = "home-manager";
    rev = "3c875267afdac6348e5e7177df10364db8bb5edd";
    sha256 = "0wz73dsjpa4847n3j24lm7s9il622pgmhrqmjibzka9bk5wl4wzs";
  };
  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = let
    dot = "${src}/home-manager/home-manager" ;
    mod = if modulesPath == null then "${src}/modules" else modulesPath;

  in ''
    install -v -D -m755 ${dot} $out/bin/home-manager

    substituteInPlace $out/bin/home-manager \
      --subst-var-by bash "${bash}" \
      --subst-var-by coreutils "${coreutils}" \
      --subst-var-by less "${less}" \
      --subst-var-by MODULES_PATH '${mod}:${dot}.nix' \
      --subst-var-by HOME_MANAGER_EXPR_PATH "${dot}.nix"\
      --subst-var-by HOME_MANAGER_PATH '${src}'


  '';

  meta = with stdenv.lib; {
    description = "A user environment configurator";
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
