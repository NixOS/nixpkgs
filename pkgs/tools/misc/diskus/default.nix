{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "diskus";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "diskus";
    rev = "v${version}";
    sha256 = "sha256-SKd2CU0F2iR4bSHntu2VKvZyjjf2XJeXJG6XS/fIBMU=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-qNXv6Z9sKl7rol78UTOSRFML/JCGfOJMGOdt49KHD50=";

  meta = with lib; {
    description = "A minimal, fast alternative to 'du -sh'";
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
