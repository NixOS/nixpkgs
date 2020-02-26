{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hbqvjv9h1aghpyrl03w5f4j8gjy6n9lx83rmpsh5p7yd9ahwmf9";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "08lizhag7aqz3a59gaapsymn7sf9c6im1aw64n0r9a5advhwdh18";

  meta = with stdenv.lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = [ maintainers."0x4A6F" ];
    platforms = platforms.linux;
  };
}
