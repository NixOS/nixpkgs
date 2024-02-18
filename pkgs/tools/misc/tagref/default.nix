{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IeGWaPoq4AJAQjsIHa7dWNuIBB3JZr6WBzh63+xRYco=";
  };

  cargoHash = "sha256-9Xkbj1PS+mlcB/f9rvcMBGUCCngkcfom6M6Zvp7Dgrg=";

  meta = with lib; {
    description = "Manage cross-references in your code";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
    mainProgram = "tagref";
  };
}
