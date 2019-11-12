{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "eva";
  version = "0.2.5";

  cargoSha256 = "1zns4xspw9w1f84sf8cz30mp2fl1jyjc2ca09gkqhzhgaj055y7k";

  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1vqr6z4vicqx1lm5ll09za4jh8rki2qbav1pawz15hqqzps3y8h1";
  };

  cargoPatches = [ ./Cargo.lock.patch ];

  meta = with stdenv.lib; {
    description = "A calculator REPL, similar to bc";
    homepage = https://github.com/NerdyPepper/eva;
    license = licenses.mit;
    maintainers = with maintainers; [ nrdxp ];
  };
}
