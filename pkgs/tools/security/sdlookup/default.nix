{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sdlookup";
  version = "unstable-2022-03-10";

  src = fetchFromGitHub {
    owner = "j3ssie";
    repo = pname;
    rev = "8554bfa27284c4764401dbd8da23800d4ae968a2";
    hash = "sha256-c6xAgOxle51waiFsSWvwO9eyt1KXuM0dEeepVsRQHkk=";
  };

  vendorSha256 = "sha256-j0UzucZ6kDwM+6U0ZyIW9u8XG/Bn+VUCO2vV1BbnQo0=";

  meta = with lib; {
    description = "IP lookups for open ports and vulnerabilities from internetdb.shodan.io";
    homepage = "https://github.com/j3ssie/sdlookup";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
