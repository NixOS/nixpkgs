{ lib, rustPlatform, fetchFromGitHub, makeWrapper, zig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nBncU5rM3gS5e/Qs14U/ZwAkLFLdNuO2DhSQW+7xGQk=";
  };

  cargoSha256 = "sha256-Zq+RG36aeNd8G+LSdiyLK8SYC0MckGUIBTvia4H9OJY=";

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
