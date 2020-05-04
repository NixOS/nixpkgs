{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "drill";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pname;
    rev = version;
    sha256 = "0aqd709fg0ha0lzri2p4pgraxvif7z8zcm8rx7sk6s2n605sc4gn";
  };

  cargoSha256 = "1c8vmyf388kbbs56h8b62nxgxvgy9yj9cnmvax6ycnslkcwmvld0";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with stdenv.lib; {
    description = "HTTP load testing application inspired by Ansible syntax";
    homepage = "https://github.com/fcsonline/drill";
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}
