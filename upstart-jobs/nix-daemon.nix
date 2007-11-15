{config, pkgs, nix, nixEnvVars}:

{
  name = "nix-daemon";
  
  job = "
    start on startup
    stop on shutdown
    respawn
    script
      export PATH=${if config.nix.distributedBuilds then "${pkgs.openssh}/bin:" else ""}${pkgs.openssl}/bin:${nix}/bin:$PATH
      ${nixEnvVars}
      exec ${nix}/bin/nix-worker --daemon > /dev/null 2>&1
    end script
  ";

}
