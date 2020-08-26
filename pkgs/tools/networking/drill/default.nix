{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "drill";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pname;
    rev = version;
    sha256 = "0pcc91nk68z7hlhj7xvh6v3rybxpy6bzv3pzjcyaq7l0szjljrpw";
  };

  cargoSha256 = "1611w8b60d3x16ik8v96za0mkr5p0f9gdpz0awprfgj6c3r6s16m";

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = [ ]
    ++ stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "HTTP load testing application inspired by Ansible syntax";
    homepage = "https://github.com/fcsonline/drill";
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}
