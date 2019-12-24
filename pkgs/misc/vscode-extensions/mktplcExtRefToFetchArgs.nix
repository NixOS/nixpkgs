ext: 
{
  url = "https://${ext.publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${ext.publisher}/extension/${ext.name}/${ext.version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage";
  sha256 = ext.sha256;
  # The `*.vsix` file is in the end a simple zip file. Change the extension
  # so that existing `unzip` hooks takes care of the unpacking.
  name = "${ext.publisher}-${ext.name}.zip";
}
