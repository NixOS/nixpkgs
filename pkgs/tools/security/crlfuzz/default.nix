{ buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "crlfuzz";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = pname;
    rev = "v${version}";
    sha256 = "03g7z7cczn52hvg6srp1i5xhdbpia226adrh2d54cs640063bx3m";
  };

  vendorSha256 = "19cj07f7d3ksp7lh5amdjz1s8p7xmqbwal4vp61al82n8944ify8";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Tool to scan for CRLF vulnerability";
    homepage = "https://github.com/dwisiswant0/crlfuzz";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
