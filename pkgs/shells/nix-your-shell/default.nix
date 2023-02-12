{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kdZFwMHatnhdXGSIItuE3g27qqUKqT/Hkbz13Ba5eq4=";
  };

  cargoSha256 = "sha256-U4nN/N345XFRj0L9cLJAjRuND0W3OE6XEB/z3zXaUiQ=";

  meta = with lib; {
    description = "A `nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
