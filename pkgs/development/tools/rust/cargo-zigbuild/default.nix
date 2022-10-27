{ lib, rustPlatform, fetchFromGitHub, makeWrapper, zig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XeeMROSO012vo9nOsVUdFFLTj+9mSYtg+EFHJxs+kl0=";
  };

  cargoSha256 = "sha256-KuxGUDS2xJLa32mON+JI7tT+zAheOk7M5FYtSDJlF1A=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-zigbuild \
      --prefix PATH : ${zig}/bin
  '';

  meta = with lib; {
    description = "A tool to compile Cargo projects with zig as the linker";
    homepage = "https://github.com/messense/cargo-zigbuild";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
