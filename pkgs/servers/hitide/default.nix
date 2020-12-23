{ stdenv, fetchgit, rustPlatform
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "hitide";
  version = "0.8.0";

  src = fetchgit {
    url = "https://git.sr.ht/~vpzom/hitide";
    rev = "v${version}";
    sha256 = "0ln41qfw3rsr37yihbjbp3qdp4gc6rhkb9kpzw2hmkaz40r9hybp";
  };

  cargoSha256 = "0nph97gq151caga45814xw77qljpccv0ac023nmafhrci1if2zmg";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with stdenv.lib; {
    description = "A frontend for lotide";
    homepage = "https://sr.ht/~vpzom/lotide/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = with platforms; linux;
  };
}

