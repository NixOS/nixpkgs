{ lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fEFMzBLQl93QmaviJXOZkiJ3cqYKNOiz3a+CZL7nyRI=";
  };

  cargoHash = "sha256-dvSP1djkjvdm04lsdxZsxS+0R0PI+jo8blg3zOQcBrU=";

  meta = with lib; {
    description = "Tagref helps you refer to other locations in your codebase.";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
  };
}
