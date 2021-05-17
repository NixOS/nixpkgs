{ stdenv, lib, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = version;
    sha256 = "sha256-8CBsLOAF0JnRMe7qLod6UDPGLMPwqDm0Z5BjB4KCkBc=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];
  cargoSha256 = "sha256-S/RAt3tCIlaSqIHqP5C+QK9aQq+4CO/MW2toUo9kVKk=";

  meta = with lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.all;
  };
}
