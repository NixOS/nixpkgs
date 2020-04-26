{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-04-21-1";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "e0aea74abf090bc9dc499332b28bf03640c162f8";
    sha256 = "1gayjyh0x0axc1xak38zkdhvx6fy8pwlniqsirqy2mwcgkkll9i5";
  };

  modSha256 = "1pddabyyz6q1snx9j7yv7dchasqa1y8nbpb5zrwmrpnwpns8kxl7";

  meta = with stdenv.lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
