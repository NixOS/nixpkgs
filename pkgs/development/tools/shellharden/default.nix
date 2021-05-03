{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "shellharden";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "anordal";
    repo = pname;
    rev = "v${version}";
    sha256 = "1003kgnql0z158d3rzz8s3i7s7rx9hjqqvp3li8xhzrgszvkgqk4";
  };

  cargoSha256 = "1h4wp9xs9nq90ml2km9gd0afrzri6fbgskz6d15jqykm2fw72l88";

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
