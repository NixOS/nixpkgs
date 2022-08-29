{ lib
, stdenv
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "riff";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q1cI7G/c7kVwMFMjbmdbNdrU6GHVmxTxcLbAfLaMEYU=";
  };

  cargoSha256 = "sha256-vmv7SOQqAPzYgKoTJKdiRrJ5t8iU1QlZy+VSlv8FRQE";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  meta = with lib; {
    homepage = "https://github.com/DeterminateSystems/riff";
    description = "A tool that automatically provides external dependencies for software projects";
    license = licenses.mpl20;
    maintainers = teams.determinatesystems.members;
  };
}
