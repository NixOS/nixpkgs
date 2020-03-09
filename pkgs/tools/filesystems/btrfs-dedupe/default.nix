{ stdenv, fetchurl, rustPlatform, lzo, zlib }:

with rustPlatform;

buildRustPackage rec {
  pname = "btrfs-dedupe";
  version = "1.1.0";


  src = fetchurl {
    url = "https://gitlab.wellbehavedsoftware.com/well-behaved-software/btrfs-dedupe/repository/archive.tar.bz2?ref=72c6a301d20f935827b994db210bf0a1e121273a";
    sha256 = "0qy1g4crhfgs2f5cmrsjv6qscg3r66gb8n6sxhimm9ksivhjyyjp";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "1sz3fswb76rnk7x4kpl1rnj2yxbhpx6q8kv8xxiqdr7qyphpi98r";

  buildInputs = [ lzo zlib ];

  meta = with stdenv.lib; {
    homepage = https://gitlab.wellbehavedsoftware.com/well-behaved-software/btrfs-dedupe;
    description = "BTRFS deduplication utility";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ikervagyok ];
  };
}
