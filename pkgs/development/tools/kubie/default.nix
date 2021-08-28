{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "kubie";
  version = "0.14.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "0mhm2j3i2ql7dz5vx0mwab8h8zr05ar5lfzdacgnrc293g1c01aq";
  };

  cargoSha256 = "1rfqk7dmcz5zfq9fm9kvxf5718m0v0yfjm5a8718d40zzzvam7sy";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installShellCompletion completion/kubie.bash
  '';

  meta = with lib; {
    description = "Shell independent context and namespace switcher for kubectl";
    homepage = "https://github.com/sbstp/kubie";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ illiusdope ];
  };
}
