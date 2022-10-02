{ stdenv, fetchFromGitHub, lib, rustPlatform, pkg-config, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "Lighthouse";
  version = "unstable-2021-03-28";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = "Lighthouse";
    rev = "a090889077557fe92610ca503979b5cfc0724d61";
    sha256 = "0vfl4y61cdrah98x6xcnb3cyi8rwhlws8ps6vfdlmr3dv30mbnbb";
  };

  cargoSha256 = "0aqd9ixszwq6qmj751gxx453gwbhwqi16m72bkbkj9s6nfyqihql";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "VR Lighthouse power state management";
    homepage = "https://github.com/ShayBox/Lighthouse";
    license = licenses.mit;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}

