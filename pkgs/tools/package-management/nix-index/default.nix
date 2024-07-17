{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  curl,
  sqlite,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-index";
    rev = "v${version}";
    hash = "sha256-r3Vg9ox953HdUp5Csxd2DYUyBe9u61fmA94PpcAZRqo=";
  };

  cargoHash = "sha256-c1Ivsj9of/cjEKU0lo4I9BfIUQZ3pPf2QF9fAlZTQn0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    curl
    sqlite
  ] ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    substituteInPlace command-not-found.sh \
      --subst-var out
    install -Dm555 command-not-found.sh -t $out/etc/profile.d
  '';

  meta = with lib; {
    description = "A files database for nixpkgs";
    homepage = "https://github.com/nix-community/nix-index";
    changelog = "https://github.com/nix-community/nix-index/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [
      bennofs
      figsoda
      ncfavier
    ];
  };
}
