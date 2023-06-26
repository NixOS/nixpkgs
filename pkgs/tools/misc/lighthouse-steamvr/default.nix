{ stdenv, fetchFromGitHub, lib, rustPlatform, pkg-config, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "Lighthouse";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = pname;
    rev = version;
    sha256 = "0628v6fq9dcv1w4spgnypgyxf1qw5x03yhasink5s9nqpcip0w4h";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "clap-verbosity-flag-2.0.0" = "125b8ki3dqj2kilimmvpi9wslwky8xacydi75c2bdrxpi926nya6";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "VR Lighthouse power state management";
    homepage = "https://github.com/ShayBox/Lighthouse";
    license = licenses.mit;
    maintainers = with maintainers; [ expipiplus1 bddvlpr ];
  };
}
