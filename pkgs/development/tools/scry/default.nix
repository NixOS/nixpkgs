{ lib, fetchFromGitHub, crystal, coreutils, makeWrapper, bash }:

crystal.buildCrystalPackage rec {
  pname = "scry";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "crystal-lang-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hqyG1aKY3M8q8lZEKzpUUKl9jS7NF+VMsma6+C0sCbg=";
  };

  # a bunch of tests fail when built in the sandbox while perfectly fine outside
  postPatch = ''
    rm spec/scry/{client,completion_provider,context,executable}_spec.cr
  '';

  format = "shards";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

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
