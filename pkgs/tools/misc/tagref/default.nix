{ lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ESImTR3CFe6ABCP7JHU7XQYvc2VsDN03lkVaKK9MUEU=";
  };

  cargoHash = "sha256-vqRVD5RW0j2bMF/Zl+Ldc06zyDlzRpADWqxtkvKtydE=";

  meta = with lib; {
    description = "Tagref helps you refer to other locations in your codebase.";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
  };
}
