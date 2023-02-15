{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W3MeApvqO3hBaHWu6vyrR6pniEMMKiXTAQ0bhUPbpx8=";
  };

  cargoSha256 = "sha256-M6yj4jTTWnembVX51/Xz+JtKhWJsmQ7SpipH8pHzids=";

  meta = with lib; {
    description = "A `nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
