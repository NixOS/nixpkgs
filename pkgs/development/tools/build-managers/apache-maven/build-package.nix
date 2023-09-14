{ lib
, stdenv
, maven
}:

{ src
, sourceRoot ? null
, patches ? [ ]
, pname
, version
, mvnHash ? ""
, mvnFetchExtraArgs ? { }
, mvnDepsParameters ? ""
, manualMvnArtifactIds ? [ ]
, mvnParameters ? ""
, ...
} @args:

# originally extracted from dbeaver
# created to allow using maven packages in the same style as rust

let
  fetchedMavenDeps = stdenv.mkDerivation ({
    name = "${pname}-${version}-maven-deps";
    inherit src sourceRoot patches;

    nativeBuildInputs = [
      maven
    ];

    buildPhase = ''
      runHook preBuild

      mvn dependency:go-offline -Dmaven.repo.local=$out/.m2 ${mvnDepsParameters}

      for artifactId in ${builtins.toString manualMvnArtifactIds}
      do
        echo "downloading manual $artifactId"
        mvn dependency:get -Dartifact="$artifactId" -Dmaven.repo.local=$out/.m2
      done

      runHook postBuild
    '';

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      runHook preInstall

      find $out -type f \( \
        -name \*.lastUpdated \
        -o -name resolver-status.properties \
        -o -name _remote.repositories \) \
        -delete

      runHook postInstall
    '';

    # don't do any fixup
    dontFixup = true;
    outputHashAlgo = if mvnHash != "" then null else "sha256";
    outputHashMode = "recursive";
    outputHash = mvnHash;
  } // mvnFetchExtraArgs);
in
stdenv.mkDerivation (builtins.removeAttrs args [ "mvnFetchExtraArgs" ] // {
  inherit fetchedMavenDeps;

  nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [
    maven
  ];

  buildPhase = ''
    runHook preBuild

    mvnDeps=$(cp -dpR ${fetchedMavenDeps}/.m2 ./ && chmod +w -R .m2 && pwd)
    mvn package -o -nsu "-Dmaven.repo.local=$mvnDeps/.m2" ${mvnParameters}

    runHook postBuild
  '';

  meta = args.meta or { } // {
    platforms = args.meta.platforms or maven.meta.platforms;
  };
})
