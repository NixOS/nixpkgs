{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, libiconv
, libgit2
, cmake
, fetchpatch
, pkg-config
, nixosTests
, Security
, Foundation
, Cocoa
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mumlnY9KGKdS3x4U84J4I8m5uMJI7SZR52aT6DPi/MM=";
  };

  nativeBuildInputs = [ installShellFiles cmake ]
    ++ lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = [ libgit2 ] ++ lib.optionals stdenv.isDarwin [ libiconv Security Foundation Cocoa ];

  buildNoDefaultFeatures = true;
  # the "notify" feature is currently broken on darwin
  buildFeatures = if stdenv.isDarwin then [ "battery" ] else [ "default" ];

  postInstall = ''
    installShellCompletion --cmd starship \
      --bash <($out/bin/starship completions bash) \
      --fish <($out/bin/starship completions fish) \
      --zsh <($out/bin/starship completions zsh)
  '';

  cargoPatches = [
    # Bump chrono dependency to fix panic when no timezone
    (fetchpatch {
      url = "https://github.com/starship/starship/commit/e652e8643310c3b41ce19ad05b8168abc29bb683.patch";
      sha256 = "sha256-iGYLJuptPMc45E7o+GXjIx7y2PxuO1mGM7xSopDBve0=";
    })
  ];

  cargoSha256 = "sha256-w7UCExSkgEY52D98SSe2EkuiwtjM6t0/uTiafrtEBaU=";

  preCheck = ''
    HOME=$TMPDIR
  '';

  passthru.tests = {
    inherit (nixosTests) starship;
  };

  meta = with lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras danth davidtwco Br1ght0ne Frostman marsam ];
  };
}
