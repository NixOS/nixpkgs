{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "air";
  version = "1.27.8";

  src = fetchFromGitHub {
    owner = "cosmtrek";
    repo = "air";
    rev = "v${version}";
    sha256 = "sha256-CVx4TDDAVIrJ3lnD2AIuxhmTV+/sIA0viX20zFkznNc=";
  };

  vendorSha256 = "sha256-dloXz1hiKAQUmSQv1rLbE5vYrZpKAcwakC71AFXWZqM=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/cosmtrek/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}
