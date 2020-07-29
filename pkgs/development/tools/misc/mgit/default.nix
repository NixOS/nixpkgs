{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mgit";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "koozz";
    repo = pname;
    rev = version;
    sha256 = "0lsph259vwxrj8nprkz6dr2nahbl7h037zi6z8w8zgpcg0fs17y6";
  };

  cargoSha256 = "1a0sznzn1vmavs4l3wmpx3qjh98sknz3fjybsmicch25z3j75iyi";

  meta = with stdenv.lib; {
    description = "A utility that performs git actions on multiple directories within the current tree";
    homepage = "https://github.com/koozz/mgit";
    license = licenses.mit;
    maintainers = with maintainers; [ koozz ];
    platforms = platforms.all;
  };
}
