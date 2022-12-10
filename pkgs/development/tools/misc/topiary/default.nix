{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "unstable-2022-12-02";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "ae861a30097bd6297f553eb0ea2597f86f16d156";
    sha256 = "sha256-WVrl+LxWSbHkbFGbkUhmw4Klwg6CzfnLAz8F0mF0kb8=";
  };

  cargoSha256 = "sha256-qoCOcYp1NYz/YhIBP6AkCCudVLpqhztRehc2xZoYp9A=";

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
