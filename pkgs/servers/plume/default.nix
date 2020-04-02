{ stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, libzip
, gnupg,
}:

rustPlatform.buildRustPackage rec {
  pname = "plume";
  version = "0.4.0-alpha-4";

  src = fetchFromGitHub {
    owner = "plume-org";
    repo = "plume";
    rev = version;
    sha256 = "0ccf7ihpjg261r0znwaasrzakw3jwh5kw202px241bd2vqlf9cv5";
  };

  cargoSha256 = "1xdnmcvga048av7xfvvgd646q958kl1cw2a7i4m85gjvqq2mp96g";

  meta = with stdenv.lib; {
    description = "Serverless Information Tracker";
    homepage = "https://joinplu.me";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.all;
  };
}

