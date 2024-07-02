{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "roogle";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "hkmatsumoto";
    repo = pname;
    rev = version;
    sha256 = "1h0agialbvhhiijkdnr47y7babq432limdl6ag2rmjfs7yishn4r";
  };

  cargoHash = "sha256-CzFfFKTmBUAafk8PkkWmUkRIyO+yEhmCfN1zsLRq4Iw=";

  postInstall = ''
    mkdir -p $out/share/roogle
    cp -r assets $out/share/roogle
  '';

  meta = with lib; {
    description = "Rust API search engine which allows you to search functions by names and type signatures";
    mainProgram = "roogle";
    homepage = "https://github.com/hkmatsumoto/roogle";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
