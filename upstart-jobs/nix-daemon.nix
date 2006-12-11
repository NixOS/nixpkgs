{nix}:

{
  name = "nix-daemon";
  
  job = "
    start on startup
    stop on shutdown
    script
      export NIX_CONF_DIR=/nix/etc/nix
      exec ${nix}/bin/nix-worker --daemon > /dev/null 2>&1
    end script
  ";

}
