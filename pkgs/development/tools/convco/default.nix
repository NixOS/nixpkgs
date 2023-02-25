{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, cmake
, libiconv
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "convco";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "convco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Fv1yaBnfn/wik1Ix24shwfritwxno3NoeJgHPsHgZOI=";
  };

  cargoHash = "sha256-q0VrN+5Ypq4ga/gI5MlyRaMdD8NxzuaZ804KaRQzpRs=";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "A Conventional commit cli";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ hoverbear ];
  };
}
