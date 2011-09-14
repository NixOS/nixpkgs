{ pkgs, ... }:

{
  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.mysql.enable = true;
	services.mysql.replication.role = "master";
	services.mysql.initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];
      };
  };

  testScript = ''
    startAll;

    $master->waitForJob("mysql");
    $master->sleep(10); # Hopefully this is long enough!!
    $master->mustSucceed("echo 'use testdb; select * from tests' | mysql -u root -N | grep 4");
  '';
}
