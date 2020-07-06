{ stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, libzip
, gnupg,
}:

rustPlatform.buildRustPackage rec {
  pname = "plume";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "plume-org";
    repo = "plume";
    rev = version;
    sha256 = "0bhl7r8ri0wd8q7vblxlfn3lj7v78qcw2cn9nwad78jsa8y3xyl5";
  };

  cargoSha256 = "1cihgxsgchx8ihlmnzf62jd8wy4sf9vfmvijxz7fgh8wagnx7h6q";

  meta = with stdenv.lib; {
    description = "Serverless Information Tracker";
    homepage = "https://joinplu.me";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.all;
  };
}

