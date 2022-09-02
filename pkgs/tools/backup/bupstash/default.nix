{ stdenv, lib, fetchFromGitHub, installShellFiles, rustPlatform, ronn, pkg-config, libsodium }:
rustPlatform.buildRustPackage rec {
  pname = "bupstash";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "andrewchambers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9yWQQ8uzDkN3Pi2OiEn+oEazc3nH53dF2GswBCu8d3c=";
  };

  cargoSha256 = "sha256-JAclSUFuQk768cgDEvG1rxux2xBGHl1d/NAoxw161YU=";

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
    # = note: Undefined symbols for architecture x86_64:
    #           "_utimensat", referenced from:
    # https://github.com/NixOS/nixpkgs/issues/101229
    broken = (stdenv.isDarwin && stdenv.isx86_64);
    maintainers = with maintainers; [ andrewchambers ];
  };
}
