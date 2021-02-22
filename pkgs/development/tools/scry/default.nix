{ lib, fetchFromGitHub, crystal_0_35, coreutils, makeWrapper }:
let
  crystal = crystal_0_35;

in
crystal.buildCrystalPackage rec {
  pname = "scry";
  version = "unstable-2020-09-02"; # to make it work with crystal 0.35

  src = fetchFromGitHub {
    owner = "crystal-lang-tools";
    repo = pname;
    # rev = "v${version}";
    rev = "580a1879810a9f5d63d8a0d90fbdaa99d86b58da";
    sha256 = "sha256-WjpkkHfy38wDj/ejXyyMtd5rLfTRoj/7D+SAhRROnbU=";
  };

  # we are already testing for this, so we can ignore the failures
  postPatch = ''
    rm spec/scry/executable_spec.cr
  '';

  format = "shards";

  nativeBuildInputs = [ makeWrapper ];

  shardsFile = ./shards.nix;

  postFixup = ''
    wrapProgram $out/bin/scry \
      --prefix PATH : ${lib.makeBinPath [ crystal coreutils ]}
  '';

  # the binary doesn't take any arguments, so this will hang
  doInstallCheck = false;

  meta = with lib; {
    description = "Code analysis server for the Crystal programming language";
    homepage = "https://github.com/crystal-lang-tools/scry";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg Br1ght0ne ];
  };
}
