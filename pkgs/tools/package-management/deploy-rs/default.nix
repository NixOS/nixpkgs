{ stdenv, lib, fetchFromGitHub, rustPlatform, CoreServices, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "deploy-rs";
  version = "unstable-2022-08-05";

  src = fetchFromGitHub {
    owner = "serokell";
    repo = "deploy-rs";
    rev = "41f15759dd8b638e7b4f299730d94d5aa46ab7eb";
    sha256 = "sha256-1ZxuK67TL29YLw88vQ18Y2Y6iYg8Jb7I6/HVzmNB6nM=";
  };

  cargoHash = "sha256-IXmcpYcWmTGBVNwNCk1TMDOcLxkZytlEIILknUle3Rg=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices SystemConfiguration ];

  meta = with lib; {
    description = " A simple multi-profile Nix-flake deploy tool. ";
    homepage = "https://github.com/serokell/deploy-rs";
    license = licenses.mpl20;
    maintainers = [ maintainers.teutat3s ];
  };
}
