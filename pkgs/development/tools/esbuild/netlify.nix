{ lib
, buildGoModule
, fetchFromGitHub
, netlify-cli
}:

buildGoModule rec {
  pname = "esbuild";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "evanw";
    repo = "esbuild";
    rev = "v${version}";
    hash = "sha256-L/6/SyXpiMTu/3SHM2Lp+Xy0JfJl939a6KF3IwHTC6Y=";
  };
  vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";

  passthru = {
    tests = {
      inherit netlify-cli;
    };
  };

  meta = with lib; {
    description = "Fork of esbuild maintained by netlify";
    homepage = "https://github.com/netlify/esbuild";
    license = licenses.mit;
    maintainers = with maintainers; [ roberth ];
    mainProgram = "esbuild";
  };
}
