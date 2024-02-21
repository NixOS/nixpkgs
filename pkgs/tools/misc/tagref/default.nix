{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SPmpQR4RMimU6RnljmqV9z0WvDRZkc+Y+C32BnNmK/E=";
  };

  cargoHash = "sha256-VufTLK1LDQlIiNNsV9q24sHTmcT1Y7bCnhIXPRvuRAU=";

  meta = with lib; {
    description = "Manage cross-references in your code";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
    mainProgram = "tagref";
  };
}
