{
  lib,
  libedit,
  mkAppleDerivation,
  ncurses,
  pkg-config,
}:

mkAppleDerivation {
  releaseName = "remote_cmds";

  outputs = [
    "out"
    "man"
  ];

  xcodeHash = "sha256-+hC3yJwwwXr01Aa47K5dv4gL0+IlTQZU9YYgygXkTSI=";

  postPatch = ''
    # Avoid a conflict with the definition in SDK’s headers.
    sed -e '/MAXPKTSIZE/d' -i tftpd/tftp-utils.h

    # Avoid a conflict with libedit when building statically
    for file in tftpd/tftp-file.c tftpd/tftp-file.h tftp/tftp.c tftpd/tftpd.c; do
      substituteInPlace $file \
        --replace-fail read_init read_init_tftpd
    done
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libedit
    ncurses
  ];

  meta.description = "Remote commands for Darwin";
}
