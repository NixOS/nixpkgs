{ fetchFromGitHub
, cargo
, lib
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "ptags";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "ptags";
    rev = "v${version}";
    sha256 = "1xr1szh4dfrcmi6s6dj791k1ix2zbv75rqkqbyb1lmh5548kywkg";
  };

  cargoSha256 = "1rsnb4kzfb577xw7jk0939n42sv94vvspvbz783bmpy9vl53i38k";

  # Sanity check.
  checkPhase = ''
    $releaseDir/ptags --help > /dev/null
  '';

  meta = with stdenv.lib; {
    description = "A parallel universal-ctags wrapper for git repository";
    homepage = "https://github.com/dalance/ptags";
    maintainers = with maintainers; [ pamplemousse ];
    license = licenses.mit;
  };
}
