{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2fS91/qeZt4JwQQeA+26RTN6zdm8/HUxG8sJDobX0+0=";
  };

  cargoHash = "sha256-e7gxNaKP0n+Zx0KaQEfNA3QsS5HZ2KIB6HJ22Ve8+EA=";

  meta = with lib; {
    mainProgram = "nix-your-shell";
    description = "A `nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
