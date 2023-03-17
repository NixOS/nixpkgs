{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "unstable-2023-01-10";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "c36d4a2253f337e1a28d497826a84754b8d833f6";
    sha256 = "sha256-0uqDuEpL9JCXzD7sQ3PDv4N1KtCSkoMoD5i402uIfas=";
  };

  cargoSha256 = "sha256-PvMjLC133rlsPrgyESuVHIf2TPCtgGQQULCQvBTIJ20=";

  postInstall = ''
    install -Dm444 languages/* -t $out/share/languages
  '';

  TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/languages";

  meta = with lib; {
    description = "A uniform formatter for simple languages, as part of the Tree-sitter ecosystem";
    homepage = "https://github.com/tweag/topiary";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
