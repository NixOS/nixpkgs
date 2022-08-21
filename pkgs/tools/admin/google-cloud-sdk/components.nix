{ stdenv
, lib
, google-cloud-sdk
, system
, snapshotPath
, ...
}:

let
  # Mapping from GCS component architecture names to Nix archictecture names
  arches = {
    x86 = "i686";
    x86_64 = "x86_64";
    # TODO arm
  };

  # Mapping from GCS component operating systems to Nix operating systems
  oses = {
    LINUX = "linux";
    MACOSX = "darwin";
    WINDOWS = "windows";
    CYGWIN = "cygwin";
  };

  # Convert an archicecture + OS to a Nix platform
  toNixPlatform = arch: os:
    let
      arch' = builtins.getAttr arch arches;
      os' = builtins.getAttr os oses;
    in
    if (builtins.hasAttr arch arches && builtins.hasAttr os oses)
    then "${arch'}-${os'}"
    else throw "unsupported architecture '${arch}' and/or os '${os}'";

  # All architectures that are supported
  allArches = builtins.attrValues arches;

  # A description of all available google-cloud-sdk components.
  # It's a JSON file with a list of components, along with some metadata
  snapshot = builtins.fromJSON (builtins.readFile snapshotPath);

  # Generate a snapshot file for a single component.  It has the same format as
  # `snapshot`, but only contains a single component.  These files are
  # installed with google-cloud-sdk to let it know which components are
  # available.
  snapshotFromComponent =
    { component
    , revision
    , schema_version
    , version
    }:
    builtins.toJSON {
      components = [ component ];
      inherit revision schema_version version;
    };

  # Generate a set of components from a JSON file describing these components
  componentsFromSnapshot =
    { components
    , revision
    , schema_version
    , version
    , ...
    }:
    lib.fix (
      self:
      builtins.listToAttrs (
        builtins.map
          (component: {
            name = component.id;
            value = componentFromSnapshot self { inherit component revision schema_version version; };
          })
          components
      )
    );

  # Generate a single component from its snapshot, along with a set of
  # available dependencies to choose from.
  componentFromSnapshot =
    # Component derivations that can be used as dependencies
    components:
    # This component's snapshot
    { component
    , revision
    , schema_version
    , version
    } @ attrs:
    let
      baseUrl = builtins.dirOf schema_version.url;
      # Architectures supported by this component.  Defaults to all available
      # architectures.
      architectures = builtins.filter
        (arch: builtins.elem arch (builtins.attrNames arches))
        (lib.attrByPath [ "platform" "architectures" ] allArches component);
      # Operating systems supported by this component
      operating_systems = builtins.filter
        (os: builtins.elem os (builtins.attrNames oses))
        component.platform.operating_systems;
    in
    mkComponent
      {
        name = component.id;
        version = component.version.version_string;
        src =
          if lib.hasAttrByPath [ "data" "source" ] component
          then "${baseUrl}/${component.data.source}"
          else "";
        sha256 = lib.attrByPath [ "data" "checksum" ] "" component;
        dependencies = builtins.map (dep: builtins.getAttr dep components) component.dependencies;
        platforms =
          if component.platform == { }
          then lib.platforms.all
          else
            builtins.concatMap
              (arch: builtins.map (os: toNixPlatform arch os) operating_systems)
              architectures;
        snapshot = snapshotFromComponent attrs;
      };

  # Filter out dependencies not supported by current system
  filterForSystem = builtins.filter (drv: builtins.elem system drv.meta.platforms);

  # Make a google-cloud-sdk component
  mkComponent =
    { name
    , version
      # Source tarball, if any
    , src ? ""
      # Checksum for the source tarball, if there is a source
    , sha256 ? ""
      # Other components this one depends on
    , dependencies ? [ ]
      # Short text describing the component
    , description ? ""
      # Platforms supported
    , platforms ? lib.platforms.all
      # The snapshot corresponding to this component
    , snapshot
    }: stdenv.mkDerivation {
      inherit name version snapshot;
      src =
        if src != "" then
          builtins.fetchurl
            {
              url = src;
              inherit sha256;
            } else "";
      phases = [ "installPhase" "fixupPhase" ];
      installPhase = ''
        mkdir -p $out/google-cloud-sdk/.install

        # If there is a source, unpack it
        if [ ! -z "$src" ]; then
          tar -xf $src -C $out/google-cloud-sdk/

          # If the source has binaries, link them to `$out/bin`
          if [ -d "$out/google-cloud-sdk/bin" ]; then
            mkdir $out/bin
            find $out/google-cloud-sdk/bin/ -type f -exec ln -s {} $out/bin/ \;
          fi
        fi

        # Write the snapshot file to the `.install` folder
        cp $snapshotPath $out/google-cloud-sdk/.install/${name}.snapshot.json
      '';
      passthru = {
        dependencies = filterForSystem dependencies;
      };
      passAsFile = [ "snapshot" ];
      meta = {
        inherit description platforms;
      };
    };
in
componentsFromSnapshot snapshot
