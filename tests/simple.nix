{ pkgs, ... }:

{
  machine = { config, pkgs, ... }: { };

  testScript =
    ''
      startAll;
      $machine->shutdown;
    '';
}
