{ stdenv, lib, fetchurl, vscode, unzip }:

let
  extendedPkgVersion = lib.getVersion vscode;
  extendedPkgName = lib.removeSuffix "-${extendedPkgVersion}" vscode.name;

  mktplcExtRefToFetchArgs = ext: {
    url = "https://${ext.publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${ext.publisher}/extension/${ext.name}/${ext.version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage";
    sha256 = ext.sha256;
    # The `*.vsix` file is in the end a simple zip file. Change the extension
    # so that existing `unzip` hooks takes care of the unpacking.
    name = "${ext.publisher}-${ext.name}.zip";
  };

  buildVscodeExtension = a@{
    name,
    namePrefix ? "${extendedPkgName}-extension-",
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

    name = namePrefix + name;

    inherit vscodeExtUniqueId;
    inherit configurePhase buildPhase dontPatchELF dontStrip;

    buildInputs = [ unzip ] ++ buildInputs;

    installPhase = ''
      mkdir -p "$out/share/${extendedPkgName}/extensions/${vscodeExtUniqueId}"
      find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/share/${extendedPkgName}/extensions/${vscodeExtUniqueId}/"
    '';

  });


  fetchVsixFromVscodeMarketplace = mktplcExtRef:
    fetchurl((mktplcExtRefToFetchArgs mktplcExtRef));

  buildVscodeMarketplaceExtension = a@{
    name ? "",
    src ? null,
    mktplcRef,
    ...
  }: assert "" == name; assert null == src;
  buildVscodeExtension ((removeAttrs a [ "mktplcRef" ]) // {
    name = "${mktplcRef.publisher}-${mktplcRef.name}-${mktplcRef.version}";
    src = fetchVsixFromVscodeMarketplace mktplcRef;
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

in

{
  inherit fetchVsixFromVscodeMarketplace buildVscodeExtension
          buildVscodeMarketplaceExtension extensionFromVscodeMarketplace
          extensionsFromVscodeMarketplace;
}
