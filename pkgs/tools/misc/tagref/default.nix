{ lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tAkRTHstXoGrSDX5h7xOpHHDOdCqdYu3AXoda84ha4g=";
  };

  cargoHash = "sha256-3pD4hocvnfQziGtDvgc4QxnCEHlmsCFK32PI1zEh9z0=";

  meta = with lib; {
    description = "Tagref helps you refer to other locations in your codebase.";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
  };
}
