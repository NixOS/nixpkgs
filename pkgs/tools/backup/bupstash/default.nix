{ lib, fetchFromGitHub, installShellFiles, rustPlatform, ronn, pkg-config, libsodium }:
rustPlatform.buildRustPackage rec {
  pname = "bupstash";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "andrewchambers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DzRGhdUxfBW6iazpCHlQ9J8IL10FVxhac8kx6yBSGNk=";
  };

  cargoSha256 = "sha256-IKk4VsO/oH4nC6F1W+JA3Agl7oXXNJ7zpP2PYpPLREU=";

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
  };
}
