{ lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-igzlSkoVffn0X/eJrNi9u0aLc17KREuUtIwxGvsF6hc=";
  };

  cargoHash = "sha256-FNgMM+fOEbkCqRPgJmGiuoUJP9NRBxjSTwFIPyaT5d0=";

  meta = with lib; {
    description = "Tagref helps you refer to other locations in your codebase.";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
  };
}
