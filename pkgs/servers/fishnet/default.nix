{ lib, stdenv, fetchurl }:

let
  version = "2.9.3";
  releaseUrl =
    "https://fishnet-releases.s3.dualstack.eu-west-3.amazonaws.com/v${version}";
  src = if stdenv.isDarwin && stdenv.isAarch64 then
    fetchurl {
      url = "${releaseUrl}/fishnet-aarch64-apple-darwin";
      hash = "sha256-PKh+qn7qfR+WdfoK+uJJ8nHpmIAkuKUbtYo+QnXvnXg=";
    }
  else if stdenv.isDarwin then
    fetchurl {
      url = "${releaseUrl}/fishnet-x86_64-apple-darwin";
      hash = "sha256-38JV2mw5hCM9DOKyD6PGFAglDo7Fhvzt+BjG6EfuHj4=";
    }
  else if stdenv.isAarch64 then
    fetchurl {
      url = "${releaseUrl}/fishnet-aarch64-unknown-linux-musl";
      hash = "sha256-yluU4eM8gGCJp14CBOYC8oUwms6KUq6OY1x79YyC7Vk=";
    }
  else
    fetchurl {
      url = "${releaseUrl}/fishnet-x86_64-unknown-linux-musl";
      hash = "sha256-IjOZOv2J8PH426lEE7j68sNhX/22dxizSu8jnrXDG7A=";
    };
in stdenv.mkDerivation {
  inherit version src;
  pname = "fishnet";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 555 $src $out/bin/fishnet
  '';

  meta = with lib; {
    description = "Distributed Stockfish analysis for lichess.org";
    homepage = "https://github.com/lichess-org/fishnet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tu-maurice thibault ];
    platforms =
      [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    mainProgram = "fishnet";
  };
}
