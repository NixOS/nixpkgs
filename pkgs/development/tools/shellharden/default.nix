{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "shellharden";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "anordal";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aBX3RXfDhlXVMV8aPO0pu3527nDoYrUDUbH6crWO/W8=";
  };

  cargoHash = "sha256-/t5dsDOokuUC0ZG8hPzsUoAvteLHWby6eKZNtnL/XUw=";

  postPatch = "patchShebangs moduletests/run";

  meta = with lib; {
    description = "Corrective bash syntax highlighter";
    mainProgram = "shellharden";
    longDescription = ''
      Shellharden is a syntax highlighter and a tool to semi-automate the
      rewriting of scripts to ShellCheck conformance, mainly focused on quoting.
    '';
    homepage = "https://github.com/anordal/shellharden";
    license = licenses.mpl20;
    maintainers = with maintainers; [ oxzi ];
  };
}
