{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.4.3";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = version;
    sha256 = "0yl7iznjyng1i3d994qrryllni702gga7h45sx8i3sgpy8544yjf";
  };

  subPackages = [ "." ];

  vendorSha256 = "1276k2hpyr7bqp6hdi576xcdcd2c8vz100jpls663z7vb2rbpvxf";

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ colemickens ];
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}