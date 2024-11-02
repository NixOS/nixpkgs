{ lib, stdenv, fetchzip, curl, libressl, libxcrypt, pkg-config, sqlite }:

let
  version = "3.1";

  src = fetchzip {
    url = "https://git.causal.agency/pounce/snapshot/pounce-${version}.tar.gz";
    sha256 = "sha256-6PGiaU5sOwqO4V2PKJgIi3kI2jXsBOldEH51D7Sx9tg=";
  };

  common = { pname, buildInputs, postConfigure ? null, meta ? null }:
    stdenv.mkDerivation {
      inherit pname version src buildInputs postConfigure meta;

      nativeBuildInputs = [ pkg-config ];

      buildFlags = [ "all" ];
      makeFlags = [
        "PREFIX=$(out)"
      ];
    };

in {
  pounce = common {
    pname = "pounce";

    buildInputs = [ libressl libxcrypt ];

    meta = with lib; {
      homepage = "https://git.causal.agency/pounce/about/";
      description = "Simple, multi-client, TLS-only IRC bouncer";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [ edef ];
    };
  };

  pounce-extra = common {
    pname = "pounce-extra";

    buildInputs = [ curl.dev libressl sqlite.dev ];

    # Pounce's configure script currently doesn't provide a way to only build
    # extras so we have to do this instead.
    postConfigure = ''
      echo "BINS = pounce-notify pounce-palaver" >> config.mk
    '';

    meta = with lib; {
      homepage = "https://git.causal.agency/pounce/about/";
      description = "Special-purpose clients for extending the Pounce IRC bouncer";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [ jbellerb ];
    };
  };
}
