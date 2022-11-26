{ lib, stdenv, fetchFromGitHub, sqlite, coreutils }:

stdenv.mkDerivation rec {
  pname = "zsh-histdb";
  version = src.rev;

  src = fetchFromGitHub {
    owner = "larkery";
    repo = pname;
    rev = "30797f0c50c31c8d8de32386970c5d480e5ab35d";
    sha256 = "sha256-PQIFF8kz+baqmZWiSr+wc4EleZ/KD8Y+lxW2NT35/bg=";
  };

  strictDeps = true;
  dontBuild = true;

  # nativeBuildInputs
  buildInputs = [ sqlite coreutils ];

  installPhase = ''
    # core plugin zsh functions
    install -D -t $out/share/zsh/plugins/histdb/ \
       zsh-histdb.plugin.zsh \
       sqlite-history.zsh \
       histdb-interactive.zsh \
       histdb-migrate \
       histdb-merge

    # Migrations -- may grow in the future.
    install -D -t $out/share/zsh/plugins/histdb/db_migrations/ \
      db_migrations/0to2.sql

    patchShebangs $out/share/zsh/plugins/histdb/histdb-migrate
    patchShebangs $out/share/zsh/plugins/histdb/histdb-merge
    substituteInPlace $out/share/zsh/plugins/histdb/histdb-merge \
        --replace sqlite3 /bin/sqlite3
    substituteInPlace $out/share/zsh/plugins/histdb/histdb-migrate \
        --replace sqlite3 /bin/sqlite3

    mkdir -p $out/bin/
    ln -s $out/share/zsh/plugins/histdb/histdb-migrate $out/bin/histdb-migrate
    ln -s $out/share/zsh/plugins/histdb/histdb-merge   $out/bin/histdb-merge
  '';

  meta = with lib; {
    homepage = "https://github.com/larkery/zsh-histdb";
    license = licenses.mit;
    description = "a small bit of zsh code that stores your history into a sqlite3 database.";
    maintainers = with maintainers; [ sielicki ];
  };
}
