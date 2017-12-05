{ stdenv, lib, fetchurl, runCommand, vscode, which }:

let
  extendedPkgVersion = lib.getVersion vscode;
  extendedPkgName = lib.removeSuffix "-${extendedPkgVersion}" vscode.name;

  mktplcExtRefToFetchArgs = ext: {
    url = "https://${ext.publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${ext.publisher}/extension/${ext.name}/${ext.version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage";
    sha256 = ext.sha256;
    name = "${ext.name}.vsix";
  };

  buildVscodeExtension = a@{
    name,
    namePrefix ? "${extendedPkgName}-extension-",
    src,
    configurePhase ? ":",
    buildPhase ? ":",
    dontPatchELF ? true,
    dontStrip ? true,
    buildInputs ? [],
    ...
  }:
  stdenv.mkDerivation (a // {

    name = namePrefix + name;

    inherit configurePhase buildPhase dontPatchELF dontStrip;

    # TODO: `which` is an encapsulation leak. It should have been hardwired
    #       as part of the `code` wrapper. 
    buildInputs = [ vscode which ] ++ buildInputs;

    unpackPhase = ''
      # TODO: Unfortunately, 'code' systematically creates its '.vscode' directory
      # even tough it has nothing to write in it. We need to redirect this
      # to a writeable location as the nix environment already has (but
      # to a non writeable one) otherwise the write will fail.
      # It would be preferrable if we could intercept / fix this at the source.
      HOME="$PWD/code_null_home" code \
        --extensions-dir "$PWD" \
        --install-extension "${toString src}"

      rm -Rf "$PWD/code_null_home"
      cd "$(find . -mindepth 1 -type d -print -quit)"
      ls -la
    '';


    installPhase = ''
      mkdir -p "$out/share/${extendedPkgName}/extensions/${name}"
      find . -mindepth 1 -maxdepth 1 | xargs mv -t "$out/share/${extendedPkgName}/extensions/${name}/"
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
    name = "${mktplcRef.name}-${mktplcRef.version}";
    src = fetchVsixFromVscodeMarketplace mktplcRef;
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

  extensionsFromVscodeMarketplace = mktplcExtRefList:
    builtins.map mktplcExtRefToExtDrv mktplcExtRefList;

in

{
  inherit fetchVsixFromVscodeMarketplace buildVscodeExtension 
          buildVscodeMarketplaceExtension extensionsFromVscodeMarketplace;
}