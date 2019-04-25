{ stdenv, fetchFromGitHub, rustPlatform, CoreServices, Security, cf-private }:

rustPlatform.buildRustPackage rec {
  pname = "lorri";
  version = "unstable-2019-04-24";

  src = fetchFromGitHub {
    owner = "target";
    repo = pname;
    rev = "71983296d121a8bc1af7dbeec78b7aa6dacf1e46";
    sha256 = "0lkv4h1z04dfy30mckh8ni613jb8f045nzgy2ap6g49x456zipay";
  };

  BUILD_REV_COUNT = 1;

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security cf-private /* for _CFURLResourceIsReachable */ ];

  cargoSha256 = "0lx4r05hf3snby5mky7drbnp006dzsg9ypsi4ni5wfl0hffx3a8g";

  # too complicated to setup, but Travis ensures a proper build
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Your project's nix-env";
    homepage = https://github.com/target/lorri;
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
