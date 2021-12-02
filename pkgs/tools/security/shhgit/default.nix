{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "shhgit";
  version = "0.4-${lib.strings.substring 0 7 rev}";
  rev = "7e55062d10d024f374882817692aa2afea02ff84";

  src = fetchFromGitHub {
    owner = "eth0izzle";
    repo = pname;
    inherit rev;
    sha256 = "1b7r4ivfplm4crlvx571nyz2rc6djy0xvl14nz7m0ngh6206df9k";
  };

  vendorSha256 = "0isa9faaknm8c9mbyj5dvf1dfnyv44d1pjd2nbkyfi6b22hcci3d";

  meta = with lib; {
    description = "Tool to detect secrets in repositories";
    homepage = "https://github.com/eth0izzle/shhgit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
