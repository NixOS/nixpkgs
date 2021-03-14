{ lib, fetchFromGitHub, installShellFiles, rustPlatform, ronn, pkg-config, libsodium }:
rustPlatform.buildRustPackage rec {
  pname = "bupstash";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "andrewchambers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4+Ra7rNvIL4SpdCkRbPBNrZeTb1dMbuwZx+D++1qsGs=";
  };

  cargoSha256 = "sha256-cZSscmH3XPfH141hZhew79/UZHsqDZRN3EoNnYkW0wA=";

  nativeBuildInputs = [ ronn pkg-config installShellFiles ];
  buildInputs = [ libsodium ];

  postBuild = ''
    RUBYOPT="-KU -E utf-8:utf-8" ronn doc/man/*.md
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
  };
}
