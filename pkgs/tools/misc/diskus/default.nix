{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "diskus";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "diskus";
    rev = "v${version}";
    sha256 = "sha256-88+U5Y2CC0PhikRO3VqoUwZEYZjwln+61OPWbLLb8T0=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  cargoHash = "sha256-7xGt+HDX20Bxwdff0Ca/D6lcT3baumeiUmIPXSh5NYM=";

  meta = with lib; {
    description = "Minimal, fast alternative to 'du -sh'";
    homepage = "https://github.com/sharkdp/diskus";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ maintainers.fuerbringer ];
    platforms = platforms.unix;
    longDescription = ''
      diskus is a very simple program that computes the total size of the
      current directory. It is a parallelized version of du -sh.
    '';
    mainProgram = "diskus";
  };
}
