{ stdenv, lib, fetchFromGitHub, openssh, debugLevel ? 0 }:

stdenv.mkDerivation {
  pname = "scponly";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "scponly";
    repo = "scponly";
    rev = "d8ca58257b9905186aa5706f35813d5f80ea07c1";
    sha256 = "U0K7lOp18ytNjh3KVFmc6vL+/tG4ETnwLEPQEhM4lXE=";
  };

  patches = [ ./scponly-fix-make.patch ];

  strictDeps = true;

  # chroot doesn't seem to work, so not enabling
  # rsync could also be optionally enabled
  configureFlags = [
    "--enable-winscp-compat"
    "scponly_PROG_SFTP_SERVER=${lib.getBin openssh}/libexec/sftp-server"
    "scponly_PROG_SCP=${lib.getBin openssh}/bin/scp"
  ];

  postInstall = lib.optionalString (debugLevel > 0) ''
    mkdir -p $out/etc/scponly && echo ${
      toString debugLevel
    } > $out/etc/scponly/debuglevel
  '';

  passthru.shellPath = "/bin/scponly";

  meta = with lib; {
    description = "A shell that only permits scp and sftp-server";
    mainProgram = "scponly";
    homepage = "https://github.com/scponly/scponly";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ wmertens ];
  };
}
