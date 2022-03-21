{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ySaPR6it/1xEf+Rnypnz5AklxWZZ8NeXpjId4ZSMIs8=";
  };

  cargoSha256 = "sha256-FLbFDJXVpWycII8mdNDphh8QVXFFnxtFgloweW+BZA0=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
