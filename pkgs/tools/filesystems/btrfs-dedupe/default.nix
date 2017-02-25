{ stdenv, fetchurl, rustPlatform, lzo, zlib }:

with rustPlatform;

buildRustPackage rec {
  name = "btrfs-dedupe-${version}";
  version = "1.1.0";


  src = fetchurl {
    url = "https://gitlab.wellbehavedsoftware.com/well-behaved-software/btrfs-dedupe/repository/archive.tar.bz2?ref=72c6a301d20f935827b994db210bf0a1e121273a";
    sha256 = "0qy1g4crhfgs2f5cmrsjv6qscg3r66gb8n6sxhimm9ksivhjyyjp";
  };

  depsSha256 = "04jlz7nzsmg86i73w75i8rmlbk635xrg8m1dfac8h17dwb29yj6a";

  buildInputs = [ lzo zlib ];

  meta = with stdenv.lib; {
    homepage = "https://gitlab.wellbehavedsoftware.com/well-behaved-software/btrfs-dedupe";
    description = "BTRFS deduplication utility";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ikervagyok ];
  };
}
