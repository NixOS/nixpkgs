{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "shellharden";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "anordal";
    repo = pname;
    rev = "v${version}";
    sha256 = "04pgmkaqjb1lmlwjjipcrqh9qcyjjkr39vi3h5fl9sr71c8g7dnd";
  };

  cargoSha256 = "0bjqgw49msl288yfa7bl31bfa9kdy4zh1q3j0lyw4vvkv2r14pf5";

  postPatch = "patchShebangs moduletests/run";

  meta = with lib; {
    description = "The corrective bash syntax highlighter";
    longDescription = ''
      Shellharden is a syntax highlighter and a tool to semi-automate the
      rewriting of scripts to ShellCheck conformance, mainly focused on quoting.
    '';
    homepage = "https://github.com/anordal/shellharden";
    license = licenses.mpl20;
    maintainers = with maintainers; [ oxzi ];
  };
}
