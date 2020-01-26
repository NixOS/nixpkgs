{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dust";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "1qbh9vgdh0xmh4c78fm0rd1sgb01n656p3cr4my7ymsy81ypx9y7";
  };

  cargoSha256 = "07ynz6y1z3rz84662d4rfl2sw1sx46a3k48z8dckr0b3fqs2zj6a";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = https://github.com/bootandy/dust;
    license = licenses.asl20;
    maintainers = [ maintainers.infinisil ];
    platforms = platforms.all;
  };
}
