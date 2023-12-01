{ fetchFromGitHub
, cargo
, ctags
, lib
, makeWrapper
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "ptags";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "ptags";
    rev = "v${version}";
    sha256 = "sha256-bxp38zWufqS6PZqhw8X5HR5zMRcwH58MuZaJmDRuiys=";
  };

  cargoHash = "sha256-Se4q4G3hzXIHHSY2YxeRHxU6+wnqR9bfrIQSOagFYZE=";

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
