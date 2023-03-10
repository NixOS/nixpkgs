{ lib
, runCommand
, rustPlatform
, fetchFromGitHub
, stdenv
, coreutils
}:

let
  # copied from flake.nix
  # tests require extra setup with nix
  custom = runCommand "custom" { } ''
    mkdir -p $out/bin
    touch $out/bin/{'foo$','foo"`'}
    chmod +x $out/bin/{'foo$','foo"`'}
  '';
in

rustPlatform.buildRustPackage rec {
  pname = "patsh";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7HXJspebluQeejKYmVA7sy/F3dtU1gc4eAbKiPexMMA=";
  };

  cargoSha256 = "sha256-R6ScpLYbEJAu7+CyJsMdljtXq7wsMojHK5O1lH+E/E8=";

  nativeCheckInputs = [ custom ];

  # see comment on `custom`
  postPatch = ''
    for file in tests/fixtures/*-expected.sh; do
      substituteInPlace $file \
        --subst-var-by cc ${stdenv.cc} \
        --subst-var-by coreutils ${coreutils} \
        --subst-var-by custom ${custom}
    done
  '';

  meta = with lib; {
    description = "A command-line tool for patching shell scripts inspired by resholve";
    homepage = "https://github.com/nix-community/patsh";
    changelog = "https://github.com/nix-community/patsh/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
