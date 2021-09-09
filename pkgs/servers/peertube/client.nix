{ yarnModulesConfig, mkYarnModulesFixed, fetchFromGitHub, server, sources, version, nodejs, stdenv, esbuild }:
rec {
  modules = mkYarnModulesFixed rec {
    inherit version;
    pname = "peertube-client-yarn-modules";
    name = "${pname}-${version}";
    packageJSON = ./client/package.json;
    yarnLock = ./client/yarn.lock;
    yarnNix = ./client/yarn.nix;
    pkgConfig = yarnModulesConfig;
  };
  dist = let
    esbuild_locked = esbuild.overrideAttrs (old: rec {
      version = "0.12.17";

      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        sha256 = "sha256-wZOBjNOgGmwIQNCrhzwGPmI/fW/yZiDqq8l4oSDTvZs=";
      };
    });
  in stdenv.mkDerivation {
    inherit version;
    pname = "peertube-client";
    src = sources;
    buildPhase = ''
      export ESBUILD_BINARY_PATH="${esbuild_locked}/bin/esbuild"
      ln -s ${server.modules}/node_modules .
      cp -a ${modules}/node_modules client/
      chmod -R +w client/node_modules
      patchShebangs .
      npm run build:client
    '';

    installPhase = ''
      mkdir $out
      cp -a client/dist $out
    '';

    buildInputs = [ nodejs ];
  };
}
