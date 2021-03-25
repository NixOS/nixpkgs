{ lib, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "drill";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pname;
    rev = version;
    sha256 = "07zz0dj0wjwrc1rmayz7s8kpcv03i0ygl4vfwsam72qd4nf6v538";
  };

  cargoSha256 = "1nbfbmm9v1yp7380zdzz7qrc7x6krwlvgn5x5yzb8yn1rc99jzx4";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = [ ]
    ++ lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "HTTP load testing application inspired by Ansible syntax";
    homepage = "https://github.com/fcsonline/drill";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
