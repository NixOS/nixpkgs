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

  modSha256 = "02c668bp1pfrd994lhg6z3hm1qg3530nk9aw1cahiwj549vxxfhm";

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ colemickens ];
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}
