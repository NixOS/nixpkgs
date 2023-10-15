{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "lurk";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "jakwai01";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7Yi77IsP/tmzrTvBVgIj2+fOXYKCT59pILeEuGuk4Y4=";
  };

  cargoHash = "sha256-Cvtg9msoYkIIlaUw4hxWy2wSrE1uORR/2R2Geq4SI4w=";

  meta = with lib; {
    description = "A simple and pretty alternative to strace";
    homepage = "https://github.com/jakwai01/lurk";
    changelog = "https://github.com/jakwai01/lurk/releases/tag/${src.rev}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
