{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, postgresql, systemd, openssl }:

# # To enable on NixOS:
# config.services.postgresql = {
#   extraPlugins = [ pkgs.pg_journal ];
#   extraConfig = "shared_preload_libraries = 'pg_journal'";
# }

stdenv.mkDerivation rec {
  name = "pg_journal-${version}";
  version = "0.2.0";

  buildInputs = [ postgresql pkgconfig systemd.dev openssl.dev ];

  src = fetchFromGitHub {
    owner  = "intgr";
    repo   = "pg_journal";
    rev    = "e3847a1ff34c0aa8e7d16646bf921f69433b39ae";
    sha256 = "0kgqw75hnm7dx9haiv26gwa8h73c39276pqkmnryn3fg469hl8wb";
  };

  patches = [
    # See: https://github.com/intgr/pg_journal/issues/1
    (fetchpatch {
      url = https://github.com/gosuai/pg_journal/commit/a8e534ee1089c35bc073113358166ce2fd9e2c99.patch;
      sha256 = "1bgc1jzhkvwc86gvf5s8qfzlr9xiqdrdbi9zgppd1zb0i4ndmqcp";
    })
  ];

  installPhase = ''
    mkdir -p $out/lib
    cp pg_journal.so $out/lib
  '';

  meta = with stdenv.lib; {
    description = "Log PostgreSQL messages to systemd journal";
    homepage    = https://github.com/intgr/pg_journal;
    maintainers = with maintainers; [ basvandijk ];
    license     = licenses.postgresql;
  };
}
