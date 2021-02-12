{ fetchFromGitHub
, cargo
, lib
, rustPlatform

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

  cargoSha256 = "0mfm6m6msxwa54l5vpx7k1kwx8wg8969wbkn08is8fpamgsacmq0";

  # Sanity check.
  checkPhase = ''
    $releaseDir/ptags --help > /dev/null
  '';

  meta = with lib; {
    description = "A parallel universal-ctags wrapper for git repository";
    homepage = "https://github.com/dalance/ptags";
    maintainers = with maintainers; [ pamplemousse ];
    license = licenses.mit;
  };
}
