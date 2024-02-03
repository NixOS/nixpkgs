{ pkgs, nuget-to-nix }:

let godot4-mono = pkgs.callPackage ./default.nix {}; in

godot4-mono.overrideAttrs (self: base: {
  pname = "godot4-mono-make-deps";

  nativeBuildInputs = base.nativeBuildInputs ++ [ nuget-to-nix ];

  nugetDeps = null;
  nugetSource = null;
  nugetConfig = null;

  shouldConfigureNuget = false;

  outputs = [ "out" ];
  buildPhase = " ";
  installPhase = ''echo "No output intended. Run make-deps.sh instead." > $out'';

  # This script is used to update the accompanying deps.nix file, a nix expression listing the
  # nuget packages that the godot-mono code depends on, along with their sha256 hashes. This
  # file is referenced by the godot-mono derivation and needs to be updated every time the
  # godot version is updated. The way it works is:
  #
  # 1) Creates and navigates to a temporary directory and then explicitly runs the unpack,
  # patch, and configure phases from the godot-mono derivation.
  # 2) Instead of building at this point, a nuget restore is performed, downloading all the
  # nuget dependencies of godot-mono into a local folder.
  # 3) Once these have been downloaded, the nuget-to-nix tool is used to generate a nix
  # expression listing the locally obtained nuget packages, along with their sha256 hashes.
  # 4) This nix expression is saved as deps.nix in the PWD.
  #
  # This process is impure, because it entails downloading files with unknown hashes, so it
  # is run manually by the maintainer within a nix-shell environment. Running the accompanying
  # make-deps.sh instead simplifies this.
  makeDeps = ''
    set -e
    outdir="$(pwd)"
    wrkdir="$(mktemp -d)"
    trap 'rm -rf -- "$wrkdir"' EXIT
    pushd "$wrkdir" > /dev/null
      unpackPhase
      cd source
      patchPhase
      configurePhase

      # Without RestorePackagesPath set, it restores packages to a temp directory. Specifying
      # a path ensures we have a place to run nuget-to-nix.
      nugetRestore() { dotnet restore --packages ~/.nuget/packages $1; }

      nugetRestore modules/mono/glue/GodotSharp/GodotSharp.sln
      nugetRestore modules/mono/editor/GodotTools/GodotTools.sln
      nugetRestore modules/mono/editor/Godot.NET.Sdk/Godot.NET.Sdk.sln

      nuget-to-nix ~/.nuget/packages > "$outdir"/deps.nix
    popd > /dev/null

  '';

  meta = base.meta // {
    description = "Derivation with no output that exists to provide an environment for make-deps.sh";
  };
})
