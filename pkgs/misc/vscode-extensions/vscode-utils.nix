{ stdenv, lib, writeShellScriptBin, fetchurl, vscode, unzip }:

let

  buildVscodeExtension = a@{
    name,
    src,
    # Same as "Unique Identifier" on the extension's web page.
    # For the moment, only serve as unique extension dir.
    vscodeExtUniqueId,
    configurePhase ? ":",
    buildPhase ? ":",
    dontPatchELF ? true,
    dontStrip ? true,
    buildInputs ? [],
    ...
  }:
  stdenv.mkDerivation ((removeAttrs a [ "vscodeExtUniqueId" ]) //  {

    name = "vscode-extension-${name}";

    inherit vscodeExtUniqueId;
    inherit configurePhase buildPhase dontPatchELF dontStrip;

    installPrefix = "${vscodeExtUniqueId}";

    buildInputs = [ unzip ] ++ buildInputs;

    installPhase = ''

      runHook preInstall

      mkdir -p "$out/$installPrefix"
      find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"

      runHook postInstall
    '';

  });

  fetchVsixFromVscodeMarketplace = mktplcExtRef:
    fetchurl((import ./mktplcExtRefToFetchArgs.nix mktplcExtRef));

  buildVscodeMarketplaceExtension = a@{
    name ? "",
    src ? null,
    vsix ? null,
    mktplcRef,
    ...
  }: assert "" == name; assert null == src;
  buildVscodeExtension ((removeAttrs a [ "mktplcRef" "vsix" ]) // {
    name = "${mktplcRef.publisher}-${mktplcRef.name}-${mktplcRef.version}";
    src = if (vsix != null)
      then vsix
      else fetchVsixFromVscodeMarketplace mktplcRef;
    vscodeExtUniqueId = "${mktplcRef.publisher}.${mktplcRef.name}";
  });

  mktplcRefAttrList = [
    "name"
    "publisher"
    "version"
    "sha256"
  ];

  mktplcExtRefToExtDrv = ext:
    buildVscodeMarketplaceExtension ((removeAttrs ext mktplcRefAttrList) // {
      mktplcRef = ext;
    });

  extensionFromVscodeMarketplace = mktplcExtRefToExtDrv;
  extensionsFromVscodeMarketplace = mktplcExtRefList:
    builtins.map extensionFromVscodeMarketplace mktplcExtRefList;

  vscodeWithConfiguration = (userParams : import ./vscodeWithConfiguration.nix {
   inherit lib vscode extensionsFromVscodeMarketplace writeShellScriptBin;
  } // userParams);

  
  vscodeExts2nix = (userParams : import ./vscodeExts2nix.nix {
    inherit lib vscode;
  } // userParams);

  vscodeEnv = (userParams : import ./vscodeEnv.nix {
    inherit lib writeShellScriptBin extensionsFromVscodeMarketplace vscode;
  } // userParams );

in 

{
  inherit fetchVsixFromVscodeMarketplace buildVscodeExtension
          buildVscodeMarketplaceExtension extensionFromVscodeMarketplace
          extensionsFromVscodeMarketplace
          vscodeWithConfiguration vscodeExts2nix vscodeEnv;
}
