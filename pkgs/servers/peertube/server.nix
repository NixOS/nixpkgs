{ yarnModulesConfig, mkYarnModulesFixed, sources, version, nodejs, stdenv }:
rec {
  modules = mkYarnModulesFixed rec {
    inherit version;
    pname = "peertube-server-yarn-modules";
    name = "${pname}-${version}";
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
    pkgConfig = yarnModulesConfig;
  };
  dist = stdenv.mkDerivation {
    inherit version;
    pname = "peertube-server";
    src = sources;
    buildPhase = ''
      ln -s ${modules}/node_modules .
      patchShebangs scripts/build/server.sh
      npm run build:server
    '';

    installPhase = ''
      mkdir $out
      cp -a dist $out
    '';

    nativeBuildInputs = [ nodejs ];
  };
}
