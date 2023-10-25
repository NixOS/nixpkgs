{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage {
  pname = "gridlock";
  version = "unstable-2023-03-03";

  outputs = [ "out" "nyarr" ];

  src = fetchFromGitHub {
    owner = "lf-";
    repo = "gridlock";
    rev = "15261abdb179e1d7e752772bf9db132b3ee343ea";
    hash = "sha256-rnPAEJH3TebBH6lqgVo7B+nNiArDIkGDnIZWcteFNEw=";
  };

  cargoHash = "sha256-EPs5vJ2RkVXKxrTRtbT/1FbvCT0KJtNuW2WKIUq7G0U=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postInstall = ''
    moveToOutput bin/nyarr $nyarr
  '';

  meta = with lib; {
    description = "Nix compatible lockfile manager, without Nix";
    homepage = "https://github.com/lf-/gridlock";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
