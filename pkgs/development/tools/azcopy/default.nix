{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.10.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "sha256-gWU219QlV+24RxnTHqQzQeGZHzVwmBXNKU+3QI6WvHI=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-d965Rt8W74bsIZAZPZLe3twuUpp4wrnNc0qwjsKikOE=";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with lib; {
    maintainers = with maintainers; [ colemickens ];
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}
