{nix, openssl}:

{
  name = "nix-daemon";
  
  job = "
    start on startup
    stop on shutdown
    env NIX_CONF_DIR=/nix/etc/nix
    respawn
    script
        export PATH=${openssl}/bin:$PATH
        exec ${nix}/bin/nix-worker --daemon > /dev/null 2>&1
    end script
  ";

}
