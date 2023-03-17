{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nkeys";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "06wbmb3cxjrcfvgfbn6rdfzb4pfaaw11bnvl1r4kig4ag22qcz7b";
  };

  vendorSha256 = "0kiqlw2411x5c1pamq3mn5wcm8mdn91avwg8xh2a7sy3kqw5d26d";

  meta = with lib; {
    description = "Public-key signature system for NATS";
    homepage = "https://github.com/nats-io/nkeys";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nk";
  };
}
