{ lib
, mixRelease
, callPackage
, fetchMixDeps
, fetchFromGitLab
, git
, cmake
, gnumake
}:

let
  cldrLocales = callPackage ./cldrLocales.nix { };
  js = callPackage ./js.nix { };
in
mixRelease rec {
  pname = "mobilizon";
  version = "1.1.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "framasoft";
    repo = pname;
    rev = version;
    sha256 = "1cmqpakjlafsnbk6c1vb6xzi5d2gwfihqxavbznjljk88wr2p4hr";
  };

  nativeBuildInputs = [ git cmake gnumake ];

  mixDeps = fetchMixDeps {
    inherit src pname version;
    sha256 = "0cxpibgm9lfymicprpxa3d5i32lpwkgg107913bvyg53lajfbwpc";
  };

  preBuild = ''
    # Else, the ex_cldr package will try to download locales at build time
    cp -a ${cldrLocales}/* $MIX_DEPS_PATH/ex_cldr/priv/cldr/locales/

    # Install the compiled js part
    cp -a "${js}/libexec/mobilizon/deps/priv/static" ./priv
  '';

  meta = with lib; {
    description = "Mobilizon is an online tool to help manage your events, your profiles and your groups";
    homepage = "https://joinmobilizon.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ minijackson ];
  };
}
