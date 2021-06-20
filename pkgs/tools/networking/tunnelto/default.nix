{ lib, stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tunnelto";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "agrinman";
    repo = pname;
    rev = version;
    sha256 = "1vvb619cq3n88y2s8lncwcyrhb5s4gpjfiyia91pilcpnfdb04y2";
  };

  cargoSha256 = "1pjd62yz7pavcinc96g2x0f5giadl9aqvz1i5vhfanh6mj6mrbl1";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = [ ]
    ++ lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Expose your local web server to the internet with a public URL";
    homepage = "https://tunnelto.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
