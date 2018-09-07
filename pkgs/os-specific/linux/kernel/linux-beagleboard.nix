{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, ubootTools, dtc, ... } @ args:

let
  modDirVersion = "4.14.12";
  tag = "r23";
in
stdenv.lib.overrideDerivation (buildLinux (args // rec {
  version = "${modDirVersion}-ti-${tag}";
  inherit modDirVersion;

  src = fetchFromGitHub {
    owner = "beagleboard";
    repo = "linux";
    rev = "${version}";
    sha256 = "07hdv2h12gsgafxsqqr7b0fir10rv9k66riklpjba2cg6x0p2nr4";
  };

  kernelPatches = args.kernelPatches;

  features = {
    efiBootStub = false;
  } // (args.features or {});

  extraMeta.hydraPlatforms = [ "armv7l-linux" ];
} // (args.argsOverride or {}))) (oldAttrs: {

  # This kernel will run mkuboot.sh.
  postPatch = ''
    patchShebangs scripts/
  '';

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ dtc ubootTools ];

})
