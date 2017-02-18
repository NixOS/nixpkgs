{ stdenv, fetchgit, rustPlatform, lzo, zlib }:

with rustPlatform;

buildRustPackage rec {
  name = "btrfs-dedupe-${version}";
  version = "1.0.3-git";

  src = fetchgit {
    url = "https://gitlab.wellbehavedsoftware.com/well-behaved-software/btrfs-dedupe.git";
    rev = "72c6a301";
    sha256 = "1qf3kyi7ir408d321pj2qffdnngam5g2zarb0952bm50aqcl3bh0";
  };

  depsSha256 = "04jlz7nzsmg86i73w75i8rmlbk635xrg8m1dfac8h17dwb29yj6a";

  buildInputs = [ lzo zlib ];

  meta = with stdenv.lib; {
    homepage = "https://gitlab.wellbehavedsoftware.com/well-behaved-software/btrfs-dedupe";
    description = "BTRFS deduplication utility";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ikervagyok ];
    broken = true;
  };
}
