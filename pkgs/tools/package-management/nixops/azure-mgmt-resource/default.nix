{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
}:


buildPythonPackage rec {
  version = "0.20.1";
  pname = "azure-mgmt-resource";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0slh9qfm5nfacrdm3lid0sr8kwqzgxvrwf27laf9v38kylkfqvml";
  };

  preConfigure = ''
    # Patch to make this package work on requests >= 2.11.x
    # CAN BE REMOVED ON NEXT PACKAGE UPDATE
    sed -i 's|len(request_content)|str(len(request_content))|' azure/mgmt/resource/resourcemanagement.py
  '';

  postInstall = ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
  '';

  propagatedBuildInputs = [ azure-mgmt-common ];

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
