{ stdenv, lib, fetchurl, unzip }:

let
  mktplcExtRefToFetchArgs = ext: {
    url = "https://${ext.publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${ext.publisher}/extension/${ext.name}/${ext.version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage";
    sha256 = ext.sha256;
    # The `*.vsix` file is in the end a simple zip file. Change the extension
    # so that existing `unzip` hooks takes care of the unpacking.
    name = "${ext.publisher}-${ext.name}.zip";
  };

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
