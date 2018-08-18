{ stdenv, buildHex

, getopt_0_8_2, erlware_commons_1_0_0, cf_0_2_2 }:

let
  providers_1_6_0 = buildHex {
    name = "providers";
    version = "1.6.0";
    sha256 = "0byfa1h57n46jilz4q132j0vk3iqc0v1vip89li38gb1k997cs0g";
    beamDeps = [ getopt_0_8_2 ];
  };
  bbmustache_1_0_4 = buildHex {
    name = "bbmustache";
    version = "1.0.4";
    sha256 = "04lvwm7f78x8bys0js33higswjkyimbygp4n72cxz1kfnryx9c03";
  };

in
buildHex rec {
  name = "relx-exe";
  version = "3.23.1";
  hexPkg = "relx";
  sha256 = "13j7wds2d7b8v3r9pwy3zhwhzywgwhn6l9gm3slqzyrs1jld0a9d";

  beamDeps = [
    providers_1_6_0
    getopt_0_8_2
    erlware_commons_1_0_0
    cf_0_2_2
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
