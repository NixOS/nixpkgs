{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wjCehdCZR/97nD4HsTZCiVZZb2GQaOTfyU72Ez5kjW8=";
  };

  cargoHash = "sha256-Wis6C4Wlz7NScFeKXWODA8BKmRtL7adaYxPVR13wNsg=";

  meta = with lib; {
    description = "Manage cross-references in your code";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
    mainProgram = "tagref";
  };
}
