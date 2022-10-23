{ lib
, buildGoModule
, fetchFromGitLab
}:

buildGoModule rec {
  pname = "nc4nix";
  version = "unstable-2022-08-06";

  src = fetchFromGitLab {
    domain = "git.helsinki.tools";
    owner = "helsinki-systems";
    repo = "nc4nix";
    rev = "91d92e8c339862fe81fb066fd370da7757042367";
    sha256 = "sha256-8ggYOc+w3oiY2B0Ned5B26/ZNco2vCdvScC+Ms+gOWo=";
  };

  vendorSha256 = "sha256-uhINWxFny/OY7M2vV3ehFzP90J6Z8cn5IZHWOuEg91M=";

  meta = with lib; {
    description = "Packaging helper for Nextcloud apps";
    homepage = "https://git.helsinki.tools/helsinki-systems/nc4nix";
    license = licenses.unfree;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}

