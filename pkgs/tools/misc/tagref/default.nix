{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4F9u1wzeBgYP3L6h08xMvgq62ix/SOaFaLl7uEf1j1c=";
  };

  cargoHash = "sha256-AO6BGevCoLCH4vpyrXrgF3FrjUa3lHA7ynXfk4KKigM=";

  meta = with lib; {
    description = "Manage cross-references in your code";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
    mainProgram = "tagref";
  };
}
