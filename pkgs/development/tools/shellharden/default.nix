{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "shellharden";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "anordal";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yOfGMxNaaw5ub7woShDMCJNiz6FgV5IBJN87VmORLvg=";
  };

  cargoSha256 = "sha256-o3CBnxEQNmvn+h/QArIkzi9xfZzIngvwHpkMT+PItY4=";

  postPatch = "patchShebangs moduletests/run";

  meta = with lib; {
    description = "The corrective bash syntax highlighter";
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
