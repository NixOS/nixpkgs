{ buildNpmPackage
, src
, version
}:
buildNpmPackage {
    name = "pgrok-web";
    inherit src version;
    sourceRoot = "${src.name}/pgrokd/web";

    npmDepsHash = "sha256-f4pDBoG6sTJE3aUknqUvHHpBR9KWo/B4YMrWHkGbvA8=";

    # Upstream doesn't have a lockfile
    postPatch = ''
      cp ${./package-lock.json} ./package-lock.json
      substituteInPlace ./package.json \
        --replace "../cli/dist" "$out"
    '';

    patches = [
      ./add_version_to_package.json.patch
    ];

    dontInstall = true;
    dontFixup = true;

    NODE_OPTIONS = "--openssl-legacy-provider";

    npmPackFlags = [ "--ignore-scripts" ];
  }
