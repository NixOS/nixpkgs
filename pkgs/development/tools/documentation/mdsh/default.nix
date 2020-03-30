{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    sha256 = "0y0k6rsspvpia4lssals4c3rdz9fgvlrhwd8gw38say02hn5b7ip";
  };

  cargoSha256 = "07f2ajg9jpp666915cwsjn5clmi9ghkw25qfqj0lj3kfj79n5ash";

  meta = with stdenv.lib; {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.all;
  };
}
