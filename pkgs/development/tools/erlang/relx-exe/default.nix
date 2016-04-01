{ stdenv, beamPackages, makeWrapper, fetchHex, erlang }:
  beamPackages.buildRebar3 {
    name = "relx-exe";
    version = "3.18.0";
    src = fetchHex {
      pkg = "relx";
      version = "3.18.0";
      sha256 =
        "e76e0446b8d1b113f2b7dcc713f032ccdf1dbda33d76edfeb19c2b6b686dcad7";
    };

    buildInputs = [ makeWrapper erlang ];

    beamDeps  = with beamPackages; [
      providers_1_6_0
      getopt_0_8_2
      erlware_commons_0_19_0
      cf_0_2_1
      bbmustache_1_0_4
    ];

    postBuild = ''
      HOME=. rebar3 escriptize
    '';

    postInstall = ''
      mkdir -p "$out/bin"
      cp -r "_build/default/bin/relx" "$out/bin/relx"
    '';

    meta = {
      description = "Executable command for Relx";
      license = stdenv.lib.licenses.asl20;
      homepage = "https://github.com/erlware/relx";
      maintainers = with stdenv.lib.maintainers; [ ericbmerritt ];
    };

  }
