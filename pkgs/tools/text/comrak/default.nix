{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = pname;
    rev = version;
    sha256 = "sha256-RUwJxoD6H0CgS7xyfzMLdoy19p/FuOg82EbocZh7vWs=";
  };

  cargoHash = "sha256-rbGl7jQABZu4aMpzlv49uMuKmw7U+9zLS6pAJIJajR8=";

  meta = with lib; {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/${version}/changelog.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ figsoda ];
  };
}
