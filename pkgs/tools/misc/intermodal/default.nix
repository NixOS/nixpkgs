{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "intermodal";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "1farcijm5s1836vi7h36yh0i9v48q4l98s4wprmr28z37c3l3n0b";
  };

  cargoSha256 = "1kvrra5i1g1inxpmn4shd8kgkljrk3ymfnpnhwrsnfxrqidi0h2z";

  # include_hidden test tries to use `chflags` on darwin
  checkFlagsArray = stdenv.lib.optionals stdenv.isDarwin [ "--skip=subcommand::torrent::create::tests::include_hidden" ];

  meta = with stdenv.lib; {
    description = "User-friendly and featureful command-line BitTorrent metainfo utility";
    homepage = "https://github.com/casey/intermodal";
    license = licenses.cc0;
    maintainers = with maintainers; [ filalex77 ];
  };
}
