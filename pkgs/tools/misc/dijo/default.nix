{ stdenv, lib, rustPlatform, fetchFromGitHub, ncurses, CoreServices }:
let version = "0.2.3"; in
rustPlatform.buildRustPackage {
  pname = "dijo";
  inherit version;
  buildInputs = [ ncurses ] ++ lib.optional stdenv.isDarwin CoreServices;
  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = "dijo";
    rev = "v${version}";
    sha256 = "1lcvj0pri5v64zygkf2p24vr72y39agrq1r3kb8dfgz8yy3vcz0a";
  };
  cargoSha256 = "0pm048xf8hkva8q8fjmhrdnk7h2im28ix7xy784xwkkdnilm4j7f";

  meta = with lib; {
    description = "Scriptable, curses-based, digital habit tracker";
    homepage = "https://github.com/NerdyPepper/dijo";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
  };
}
