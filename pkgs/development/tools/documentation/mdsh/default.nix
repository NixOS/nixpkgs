{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "mdsh-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    sha256 = "0sggclzghm54g4wnbab00qw4ry49min4zyw3hjwi0v741aa51xb2";
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
