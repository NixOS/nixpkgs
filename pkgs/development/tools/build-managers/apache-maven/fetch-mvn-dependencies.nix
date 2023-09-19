{ lib
, stdenv
, maven
}:

{ name ? "mvn-deps"
, src ? null
, srcs ? [ ]
, patches ? [ ]
, sourceRoot ? ""
, mvnDepsParameters ? ""
, manualMvnArtifacts ? [ ]
, nativeBuildInputs ? [ ]
, ...
} @args:

# originally extracted from dbeaver
# created to allow using maven packages in the same style as rust

let
  hash_ =
    if args ? hash then
      {
        outputHashAlgo = if args.hash == "" then "sha256" else null;
        outputHash = args.hash;
        outputHashMode = "recursive";
      }
    else if args ? sha256 then {
      outputHashAlgo = "sha256";
      outputHash = args.sha256;
      outputHashMode = "recursive";
    }
    else throw "fetchMvnDeps requires a hash for ${name}";
in
stdenv.mkDerivation ({
  inherit name src sourceRoot patches;

  nativeBuildInputs = [
    maven
  ] ++ nativeBuildInputs;

  buildPhase = ''
    runHook preBuild

    if [[ ! -f pom.xml ]]; then
      echo
      echo "ERROR: The pom.xml file doesn't exist"
      echo
      echo "pom.xml is needed to download all dependencies"
      echo

      exit 1
    fi

    mvn dependency:go-offline -Dmaven.repo.local=$out/.m2 -Dproject.build.outputTimestamp=1970-01-01T00:00:00Z -U ${mvnDepsParameters}

    for artifactId in ${builtins.toString manualMvnArtifacts}
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

  inherit (hash_) outputHashAlgo outputHash outputHashMode;
} // builtins.removeAttrs args [ "name" "sha256" "mvnDepsParameters" "manualMvnArtifacts" "nativeBuildInputs" ])
