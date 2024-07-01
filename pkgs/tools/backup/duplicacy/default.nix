{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "duplicacy";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "gilbertchen";
    repo = "duplicacy";
    rev = "v${version}";
    hash = "sha256-7LflTRBB4JG84QM46wvSJrP4o3CHV4gnR24RJgDSlDg=";
  };

  vendorHash = "sha256-4M/V4vP9XwHBkZ6UwsAxZ81YAzP4inuNC5yI+5ygQsA=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://duplicacy.com";
    description = "New generation cloud backup tool";
    platforms = platforms.linux ++ platforms.darwin;
    license = lib.licenses.unfree;
    maintainers = with maintainers; [ ffinkdevs devusb ];
  };
}
