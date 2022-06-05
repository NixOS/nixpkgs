{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp rec {
  gemdir = ./.;
  pname = "pgsync";
  exes = [ "pgsync" ];

  passthru.updateScript = bundlerUpdateScript "pgsync";

  meta = with lib; {
    description = "Sync data from one Postgres database to another (like `pg_dump`/`pg_restore`)";
    homepage    = "https://github.com/ankane/pgsync";
    license     = with licenses; mit;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
