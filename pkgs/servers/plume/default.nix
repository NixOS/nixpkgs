{ stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, libzip
, gnupg,
}:

rustPlatform.buildRustPackage rec {
  pname = "plume";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "plume-org";
    repo = "plume";
    rev = version;
    sha256 = "06y87h07q4ck7f5j1l9lybylr1y1vsrq7ffv8scnqgvqadw68qns";
  };

  cargoSha256 = "14x7g93difzwp68phf5p4h5df12xn5cxaspf4j613n3v7s11fb8j";

  meta = with stdenv.lib; {
    description = "Serverless Information Tracker";
    homepage = "https://joinplu.me";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.all;
  };
}

