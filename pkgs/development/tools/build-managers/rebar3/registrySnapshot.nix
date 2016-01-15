{stdenv, writeText, fetchFromGitHub }:

stdenv.mkDerivation rec {
    name = "hex-registry";
    rev = "329ae2b";
    version = "0.0.0+build.${rev}";

    src = fetchFromGitHub {
        owner = "erlang-nix";
        repo = "hex-pm-registry-snapshots";
        inherit rev;
        sha256 = "1rs3z8psfvy10mzlfvkdzbflgikcnq08r38kfi0f8p5wvi8f8hmh";
    };

    installPhase = ''
       mkdir -p "$out/var/hex"
       zcat "registry.ets.gz" > "$out/var/hex/registry.ets"
    '';

    setupHook = writeText "setupHook.sh" ''
        export HEX_REGISTRY_SNAPSHOT="$1/var/hex/registry.ets"
   '';
}
