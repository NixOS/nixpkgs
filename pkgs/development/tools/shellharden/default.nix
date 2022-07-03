{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "shellharden";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "anordal";
    repo = pname;
    rev = "v${version}";
    sha256 = "081b51h88hhyzn9vb9pcszz1wfdj73xwsyfn2ygz708kabzqpvdl";
  };

  cargoSha256 = "1gwlmds417szwvywvm19wv60a83inp52sf46sd05x5vahb8gv8hg";

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
