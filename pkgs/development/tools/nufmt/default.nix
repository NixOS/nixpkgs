{
  lib,
  fetchFromGitHub,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "nufmt";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "796ee834c1e31ead4c5479bf2827a4339c5d61d1";
    hash = "sha256-BwKLl8eMCrqVt9PA5SHAXxu3ypP2ePcSuljKL+wSkvw=";
  };

  cargoSha256 = "sha256-SsOnuDnWkSRA5l8D04GqSwrAlijgWZNA8VdrZvB86SQ=";

  meta = with lib; {
    description = "The nushell formatter";
    homepage = "https://github.com/nushell/nufmt";
    license = licenses.mit;
    maintainers = with maintainers; [iogamaster];
  };
}
