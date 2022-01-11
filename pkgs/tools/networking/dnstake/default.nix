{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dnstake";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "pwnesia";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mjwnb0zyqnwk26f32v9vqxc9k6zcks9nn1595mf2hck5xwn86yk";
  };

  vendorSha256 = "1xhzalx1x8js449w1qs2qdwbnz2s8mmypz9maj7jzl5mqfyhlwlp";

  meta = with lib; {
    description = "Tool to check missing hosted DNS zones";
    homepage = "https://github.com/pwnesia/dnstake";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
