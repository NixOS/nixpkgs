{ fetchFromGitHub
, cargo
, ctags
, lib
, makeWrapper
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "ptags";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "ptags";
    rev = "v${version}";
    sha256 = "sha256-hFHzNdTX3nw2OwRxk9lKrt/YpaBXwi5aE/Qn3W9PRf4=";
  };

  cargoSha256 = "sha256-cFezB7uwUznC/8NXJNrBqP0lf0sXAQBoGksXFOGrUIg=";

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
