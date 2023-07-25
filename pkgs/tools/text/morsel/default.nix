{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "morsel";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "SamLee514";
    repo = "morsel";
    rev = "v${version}";
    sha256 = "sha256-m4bCni/9rMTPhZSogpd5+ARrW11TPHSvQpdz3wUr9H4=";
  };

  cargoSha256 = "sha256-2xR2/013ocDKWS1oWitpAbSDPRwEJJqFcCIm6ZQpCoc=";

  meta = with lib; {
    description = "Command line tool to translate morse code input to text in real time";
    homepage = "https://github.com/SamLee514/morsel";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
