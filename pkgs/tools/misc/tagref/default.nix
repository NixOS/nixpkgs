{ lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BZ0by5H6yZuvksMneor02rx0kXlvO9tdpWivRDB9qDs=";
  };

  cargoHash = "sha256-w+YU0+/vba/fRYbLAmOloOuHMWbFiEyt3b0mfIvFE0Q=";

  meta = with lib; {
    description = "Tagref helps you refer to other locations in your codebase.";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
  };
}
