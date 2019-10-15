{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1im04vlhmjdwzp19pizk4bmzvybgjg40ig833qx5lbisfs74xyxw";
  };

  cargoSha256 = "0675995zh9nn690kdha3zfsa157173rxwcqz0kasbl9byjczi6sm";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
