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

  buildInputs = [ openssh ];

  # Add path to sftp-server so configure finds it
  preConfigure = "export PATH=$PATH:${openssh}/libexec";

  # chroot doesn't seem to work, so not enabling
  # rsync could also be optionally enabled
  configureFlags = [ "--enable-winscp-compat" ];

  postInstall = lib.optionalString (debugLevel > 0) ''
    mkdir -p $out/etc/scponly && echo ${
      toString debugLevel
    } > $out/etc/scponly/debuglevel
  '';

  passthru.shellPath = "/bin/scponly";

  meta = with lib; {
    description = "A shell that only permits scp and sftp-server";
    homepage = "https://github.com/scponly/scponly";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ wmertens ];
  };
}
