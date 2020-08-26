{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "intermodal";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vdla0vhvgj1yrg631jdm3kwdm1q0acw8sh2nz57dp3x7chq6ipx";
  };

  cargoSha256 = "1yl1chh243ixa9lhkmgi94w6mvnrnr7xmsh4kvj7ax693249pzjv";

  # include_hidden test tries to use `chflags` on darwin
  checkFlagsArray = stdenv.lib.optionals stdenv.isDarwin [ "--skip=subcommand::torrent::create::tests::include_hidden" ];

  meta = with stdenv.lib; {
    description = "User-friendly and featureful command-line BitTorrent metainfo utility";
    homepage = "https://github.com/casey/intermodal";
    license = licenses.cc0;
    maintainers = with maintainers; [ filalex77 ];
  };
}
