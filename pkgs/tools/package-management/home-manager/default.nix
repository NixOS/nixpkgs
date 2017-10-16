#Taken directly from
#https://github.com/rycee/home-manager/blob/9c1b3735b402346533449efc741f191d6ef578dd/home-manager/default.nix

{ bash, coreutils, less, stdenv, makeWrapper, fetchFromGitHub

  # Extra path to the Home Manager modules. If set then this path will
  # be tried before `$HOME/.config/nixpkgs/home-manager/modules` and
  # `$HOME/.nixpkgs/home-manager/modules`.
, modulesPath ? null
}:

stdenv.mkDerivation rec {
  name = "home-manager-${version}";
  version = "2017-10-11";
  src = fetchFromGitHub{
    owner = "rycee";
    repo = "home-manager";
    rev = "7e6f3364bcf0a0ec838aa4853f550a9a7b5ed027";
    sha256 = "04wl0jpha19fsnyc5a8y4pkss9by468k0i5w5bjswnaz792yji6v";
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
      --subst-var-by MODULES_PATH '${mod}' \
      --subst-var-by HOME_MANAGER_EXPR_PATH "${dot}.nix"

  '';

  meta = with stdenv.lib; {
    description = "A user environment configurator";
    maintainers = with mantainers; [ rycee ];
    platforms = platforms.linux;
    license = license.mit;
  };
}
