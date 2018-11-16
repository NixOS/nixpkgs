To update v6 (v5 is deprecated and should be removed):

1. Bump `version`, `rev`, `sha256` and `payloadVersion` in `6.nix`
2. `git clone https://github.com/DataDog/datadog-agent.git && cd datadog-agent`
3. `git checkout <tag>`
4. `nix-env -i -f https://github.com/nixcloud/dep2nix/archive/master.tar.gz`
5. `deps2nix`
6. `cp deps.nix $NIXPKGS/pkgs/tools/networking/dd-agent/deps.nix`
