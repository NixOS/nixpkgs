{nix}:

{
  name = "nix-daemon";
  
  job = "
    start on startup
    stop on shutdown
    set NIX_CONF_DIR=/nix/etc/nix
    respawn ${nix}/bin/nix-worker --daemon > /dev/null 2>&1
  ";

}
