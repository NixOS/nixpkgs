{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "krapslog";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "acj";
    repo = "krapslog-rs";
    rev = version;
    sha256 = "1yllvy3z3115aqxhnjn9rq2z67rgf2w53naygnl6ixpjhpafcr3k";
  };

  cargoSha256 = "05gvl6yiyibcdscdf9a6k28xizdr5kfqbhynfbjny2hpqqjmnxzl";

  meta = with lib; {
    description = "Visualize a log file with sparklines";
    homepage = "https://github.com/acj/krapslog-rs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
  };
}
