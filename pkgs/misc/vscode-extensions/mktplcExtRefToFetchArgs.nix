{ publisher, name, version, useMSMktplc ? false, sha256 ? "" }:
{
  url = if useMSMktplc
    then "https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
    else "https://open-vsx.org/api/${publisher}/${name}/${version}/file/${publisher}.${name}-${version}.vsix";
  sha256 = sha256;
  # The `*.vsix` file is in the end a simple zip file. Change the extension
  # so that existing `unzip` hooks takes care of the unpacking.
  name = "${publisher}-${name}.zip";
}
