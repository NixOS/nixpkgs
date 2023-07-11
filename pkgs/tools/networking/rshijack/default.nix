{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rshijack";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ys1uiUQbge/eKAog2f0wL9xM+RxuxNlsc8ZceoDJk9s=";
  };

  cargoHash = "sha256-GkoRgl0jzej8HoD2wojLg71NQcGvQZTtdD4zuvsJa4Y=";

  meta = with lib; {
    description = "TCP connection hijacker";
    homepage = "https://github.com/kpcyrd/rshijack";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.unix;
  };
}
