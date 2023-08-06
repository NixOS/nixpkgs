{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.20.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "sha256-0NUOOJu3iuKBlIi4z1Jv8e00BTsgk0dpLOgfpIKSc2A=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-byFroeXRMepN9RYak2++tT9IE8ZbT+0qJAyipHkE5WE=";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ colemickens ];
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}
