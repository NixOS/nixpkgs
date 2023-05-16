<<<<<<< HEAD
{ lib, fetchFromGitHub, installShellFiles, rustPlatform, ronn, pkg-config, libsodium }:
=======
{ stdenv, lib, fetchFromGitHub, installShellFiles, rustPlatform, ronn, pkg-config, libsodium }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
rustPlatform.buildRustPackage rec {
  pname = "bupstash";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "andrewchambers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ekjxna3u+71s1q7jjXp7PxYUQIfbp2E+jAqKGuszU6g=";
  };

  cargoSha256 = "sha256-hkGmE7WseEjMxmmPyR8C4osbdbpIt8qG9sfVGuC4d84=";

  nativeBuildInputs = [ ronn pkg-config installShellFiles ];
  buildInputs = [ libsodium ];

  postBuild = ''
    RUBYOPT="-KU -E utf-8:utf-8" ronn -r doc/man/*.md
  '';

  postInstall = ''
    installManPage doc/man/*.[1-9]
  '';

  meta = with lib; {
    description = "Easy and efficient encrypted backups";
    homepage = "https://bupstash.io";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andrewchambers ];
<<<<<<< HEAD
    mainProgram = "bupstash";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
