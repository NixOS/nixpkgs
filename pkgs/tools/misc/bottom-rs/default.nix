{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bottom-rs";
  version = "unstable-2021-04-27";

  src = fetchFromGitHub {
    owner = "bottom-software-foundation";
    repo = pname;
    rev = "3451cdadd7c4e64fe8e7f43e986a18628a741dec";
    sha256 = "0kr18q80021s1n9zzzff6w6yvbbjnk6zbbabi5b42b0rfv6fnfn2";
  };

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "0nyzg6pg69bf9vvc3r5lnhmkb9s1508c1gqcra3y43zffdlwml1y";

  meta = with lib; {
    description = "Fantastic (maybe) CLI for translating between bottom and human-readable text";
    homepage = "https://github.com/bottom-software-foundation/bottom-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ winterqt ];
  };
}
