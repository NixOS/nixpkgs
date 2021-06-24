{ lib, fetchFromGitHub, installShellFiles, rustPlatform, ronn, pkg-config, libsodium }:
rustPlatform.buildRustPackage rec {
  pname = "bupstash";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "andrewchambers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zZHJlC0OICIc3G825t7GrZwdmkaaLQKzX2IwkKigkV4=";
  };

  cargoSha256 = "sha256-KVeIF6x+gpb8vkqCtZptF5EX9G1Zv6q8L6tskN6HziM=";

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
