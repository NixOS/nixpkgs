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
  cargoSha256 = "1kgm8lc92lrg09fa2l2ajp92jkfn5n4glpgrvh6xyhhzd4pmgd9w";

  meta = with lib; {
    description = "Fantastic (maybe) CLI for translating between bottom and human-readable text";
    homepage = "https://github.com/bottom-software-foundation/bottom-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ winterqt ];
    platforms = platforms.all;
  };
}
