{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "mdsh-${version}";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    sha256 = "17pd090wpnx7i8q9pp9rhps35ahm1xn4h6pm1cfsafm072qd7rff";
  };

  cargoSha256 = "1hsnz4sj8kff9azcbw9pkr2ipxlymz4zcm4vhfwydfkdlvdncpxm";

  meta = with stdenv.lib; {
    description = "Markdown shell pre-processor";
    homepage = https://github.com/zimbatm/mdsh;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.all;
  };
}
