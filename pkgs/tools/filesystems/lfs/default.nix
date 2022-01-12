{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mTgJ2DbSQprKKy7wTMXwmUAvHS9tacs9Nk1cmEJW9Sg=";
  };

  cargoSha256 = "sha256-Oiiz7I2eCtNMauvr0K2NtB49NJ/6XWVsJ0mMyEgFb7U=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
