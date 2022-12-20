{ lib
, runCommandLocal
, buildPlatform
, xrootd
, url
, hash
}: runCommandLocal (baseNameOf url)
{
  nativeBuildInputs = [ xrootd ];
  outputHashAlgo = null;
  outputHashMode = "flat";
  outputHash = hash;
  inherit url;
}
# Set [DY]LD_LIBRARY_PATH to workaround #169677
# TODO: Remove the library path after #200830 get merged
''
  ${lib.optionalString buildPlatform.isDarwin "DY"}LD_LIBRARY_PATH=${lib.makeLibraryPath [ xrootd ]} xrdcp --force "$url" "$out"
''
