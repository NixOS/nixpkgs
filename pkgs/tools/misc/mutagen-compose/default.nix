{ stdenv, lib, buildGoModule, fetchFromGitHub, fetchzip }:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fr4Emw8S7Uu0I08Yxha+hzZF54cJZ8UQgWF4GGvWDu0=";
  };

  vendorSha256 = "sha256-P6FnDp+nEEZM/7uvSb9Zkrn2zLha816A82xN2AFNgWc=";

  doCheck = false;

  subPackages = [ "cmd/mutagen-compose" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Compose with Mutagen integration";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen-compose/releases/tag/v${version}";
    maintainers = [ maintainers.matthewpi ];
    license = licenses.mit;
  };
}
