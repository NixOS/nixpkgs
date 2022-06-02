{ lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PZ5ymYXn19PnvimofODh6su9zHdVoa3T7RCWPSO1Z6w=";
  };

  cargoSha256 = "sha256-6siqfAWFoOomqcRvW+iku28FbyKCHiDzMVIUwWP8hJM=";

  meta = with lib; {
    description = "Tagref helps you refer to other locations in your codebase.";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
  };
}
