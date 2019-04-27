To update datadog-agent v6 (v5 is deprecated and should be removed):

1. Bump `version`, `rev`, `sha256` and `payloadVersion` in `datadog-agent.nix`
2. `git clone https://github.com/DataDog/datadog-agent.git && cd datadog-agent`
3. `git checkout <tag>`
4. `nix-env -i -f https://github.com/nixcloud/dep2nix/archive/master.tar.gz`
5. `dep2nix`
6. `cp deps.nix $NIXPKGS/pkgs/tools/networking/dd-agent/datadog-agent-deps.nix`

To update datadog-process-agent:

1. Bump `version`, `rev` and `sha256` in `datadog-process-agent.nix`
2. `git clone https://github.com/DataDog/datadog-process-agent.git && cd datadog-process-agent`
3. `git checkout <tag>`
4. `nix-env -i -f https://github.com/nixcloud/dep2nix/archive/master.tar.gz`
5. `dep2nix`
6. `cp deps.nix $NIXPKGS/pkgs/tools/networking/dd-agent/datadog-process-agent-deps.nix`
