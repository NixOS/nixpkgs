{ yarnModulesConfig, mkYarnModulesFixed, server, sources, version, nodejs, stdenv }:
rec {
  modules = mkYarnModulesFixed rec {
    inherit version;
    pname = "peertube-client-yarn-modules";
    name = "${pname}-${version}";
    packageJSON = "${sources}/client/package.json";
    yarnLock = "${sources}/client/yarn.lock";
    pkgConfig = yarnModulesConfig;
  };
  dist = stdenv.mkDerivation {
    inherit version;
    pname = "peertube-client";
    src = sources;
    buildPhase = ''
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
