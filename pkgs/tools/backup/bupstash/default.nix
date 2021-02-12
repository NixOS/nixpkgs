{ lib, fetchFromGitHub, installShellFiles, rustPlatform, ronn, pkg-config, libsodium }:
rustPlatform.buildRustPackage rec {
  pname = "bupstash";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "andrewchambers";
    repo = pname;
    rev = "v${version}";
    sha256 = "013k8pr4865f5rp66fjf3a8069kmd29brxv0l20z571gy2kxs5p9";
  };

  cargoSha256 = "1d19fdy1mi65cnzkpr3i03ajss6mv1ng7a17frwpc6fzrasn83ah";

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
