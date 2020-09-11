{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "0yziqgvjjb5bblmm060li7dv1i23gpn0f75jb72z8cdf2wg1qmxb";
  };

  cargoSha256 = "1y4q6p6hbmpwdpahmspgngm842qrq1srl7319wslq9ydl09m1x3x";

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
