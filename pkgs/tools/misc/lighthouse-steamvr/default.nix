{
  stdenv,
  fetchFromGitHub,
  lib,
  rustPlatform,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage rec {
  pname = "Lighthouse";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = pname;
    rev = version;
    sha256 = "0g0cs54j1vmcig5nc8sqgx30nfn2zjs40pvv30j5g9cyyszbzwkw";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "clap-verbosity-flag-2.1.1" = "1213bsb0bpvv6621j9zicjsqy05sv21gh6inrvszqwcmj6fxxc7j";
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
    maintainers = with maintainers; [
      expipiplus1
      bddvlpr
    ];
    mainProgram = "lighthouse";
  };
}
