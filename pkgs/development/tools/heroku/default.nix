{ stdenv, fetchurl, bash, buildFHSUserEnv, makeWrapper, writeTextFile
, nodejs-6_x, postgresql, ruby }:

with stdenv.lib;

let
  version = "3.43.12";
  bin_ver = "5.4.7-8dc2c80";

  arch = {
    "x86_64-linux" = "linux-amd64";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  sha256 = {
    "x86_64-linux" = "0iqjxkdw53dvy54ahmr9yijlxrp5nbikh9z7iss93z753cgxdl06";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  fhsEnv = buildFHSUserEnv {
    name = "heroku-fhs-env";
  };

  heroku = stdenv.mkDerivation rec {
    inherit version;
    name = "heroku";

    meta = {
      homepage = "https://toolbelt.heroku.com";
      description = "Everything you need to get started using Heroku";
      maintainers = with maintainers; [ aflatter mirdhyn ];
      license = licenses.mit;
      platforms = with platforms; unix;
    };

    src = fetchurl {
      url = "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-${version}.tgz";
      sha256 = "1z7z8sl2hkrc8rdvx3h00fbcrxs827xlfp6fji0ap97a6jc0v9x4";
    };

    bin = fetchurl {
      url = "https://cli-assets.heroku.com/branches/stable/${bin_ver}/heroku-v${bin_ver}-${arch}.tar.gz";
      inherit sha256;
    };

    installPhase = ''
      cli=$out/share/heroku/cli
      mkdir -p $cli

      tar xzf $src -C $out --strip-components=1
      tar xzf $bin -C $cli --strip-components=1

      wrapProgram $out/bin/heroku \
        --set HEROKU_NODE_PATH ${nodejs-6_x}/bin/node \
        --set XDG_DATA_HOME    $out/share \
        --set XDG_DATA_DIRS    $out/share

      # When https://github.com/NixOS/patchelf/issues/66 is fixed, reinstate this and dump the fhsuserenv
      #patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      #  $cli/bin/heroku
    '';

    buildInputs = [ fhsEnv ruby postgresql makeWrapper ];

    doUnpack = false;
  };

in writeTextFile {
  name = "heroku-${version}";
  destination = "/bin/heroku";
  executable = true;
  text = ''
    #!${bash}/bin/bash -e
    ${fhsEnv}/bin/heroku-fhs-env ${heroku}/bin/heroku
  '';
}
