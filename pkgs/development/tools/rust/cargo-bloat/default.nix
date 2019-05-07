{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jpwaw8ryfvfw5ypjvli18wwv6l1r6dyz1msipdpy7nvw1qdw54h";
  };

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "1275jfzkpkzbwv927hdkv4zplmynwrm7sbirq18dwfss55cm7r7z";

  meta = with stdenv.lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = https://github.com/RazrFalcon/cargo-bloat;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}

