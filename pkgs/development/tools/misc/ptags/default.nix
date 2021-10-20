{ fetchFromGitHub
, cargo
, ctags
, lib
, makeWrapper
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

  cargoSha256 = "1pz5hvn1iq26i8c2cmqavhnri8h0sn40khrxvcdkj9q47nsj5wcx";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # `ctags` must be accessible in `PATH` for `ptags` to work.
    wrapProgram "$out/bin/ptags" \
      --prefix PATH : "${lib.makeBinPath [ ctags ]}"
  '';

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
