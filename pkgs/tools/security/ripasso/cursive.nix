{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, ncurses, python3, openssl, libgpgerror, gpgme, xorg }:

with rustPlatform;
buildRustPackage rec {
  version = "unstable-2019-08-27";
  pname = "ripasso-cursive";

  src = fetchFromGitHub {
    owner = "cortex";
    repo = "ripasso";
    rev  = "1b5ef4ae19f95f1422ba5cb09e9e689880599c40";
    sha256 = "1lh1in8knpqz4vbsmdyd4hh8y4bfhxjciysfbq3qzdpdpihgj0nn";
  };

  cargoSha256 = "0dwaa106vj7jbgshhqpjabsr0zmkg1a5syzky7jcaasvc7r7njwl";
  cargoBuildFlags = [ "-p ripasso-cursive" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    ncurses python3 openssl libgpgerror gpgme xorg.libxcb
  ];

  meta = with stdenv.lib; {
    description = "A simple password manager written in Rust";
    homepage = "https://github.com/cortex/ripasso";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sgo ];
    platforms = platforms.linux;
  };
}
