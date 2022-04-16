{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, libiconv
, libgit2
, pkg-config
, nixosTests
, Security
, Foundation
, Cocoa
}:
let
  pname = "starship";
  version = "1.6.2";
in
rustPlatform.buildRustPackage {
  inherit pname version;
  # unstable was used for a quick fix for darwin
  # revert to stable for the release after 1.5.4

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Swxc2gl3YP+0Kf+trp37rGhr5G8NT4L3Bb3lHwLm50Q=";
  };

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ libgit2 ] ++ lib.optionals stdenv.isDarwin [ libiconv Security Foundation Cocoa ];

  buildNoDefaultFeatures = true;
  # the "notify" feature is currently broken on darwin
  buildFeatures = if stdenv.isDarwin then [ "battery" ] else [ "default" ];

  postInstall = ''
    for shell in bash fish zsh; do
      STARSHIP_CACHE=$TMPDIR $out/bin/starship completions $shell > starship.$shell
      installShellCompletion starship.$shell
    done
  '';

  cargoSha256 = "sha256-UvIectx6qWkXg/yVQe11NXhh2UD0D/dMCtK1kj3ln6M=";

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
