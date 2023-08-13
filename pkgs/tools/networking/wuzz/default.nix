{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "wuzz";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H0soiKOytchfcFx17az0pGoFbA+hhXLxGJVdaARvnDc=";
  };

  patches = [
    # go 1.19 support
    # https://github.com/asciimoo/wuzz/pull/146
    (fetchpatch {
      url = "https://github.com/asciimoo/wuzz/commit/bb4c4fff794f160920df1d3b87541b28f071862c.patch";
      hash = "sha256-nbgwmST36nB5ia3mgZvkwAVqJfznvFnNyzdoyo51kLg=";
    })
  ];

  vendorHash = "sha256-oIm6DWSs6ZDKi6joxydguSXxqtGyKP21cmWtz8MkeIQ=";

  meta = with lib; {
    homepage = "https://github.com/asciimoo/wuzz";
    description = "Interactive cli tool for HTTP inspection";
    license = licenses.agpl3;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
