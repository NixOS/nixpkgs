{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q8ekLh0pw+kMIE2SP3cBgrMTfMjY5zRWR58mq5bbB8U=";
  };

  cargoSha256 = "sha256-eZM48OyYgEJl71I2iu52hKwjDrbSelR4JH/se79bBDs=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
