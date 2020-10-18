{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "175wlvn6psa3xx9g2i05xykk24wpmkr0m27rm95jyi0kzlqdc466";
  };

  cargoSha256 = "01gf8v6q2rpaik6dyxch8n2mpaxp222v32zrw19059hn3smg98l0";

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
