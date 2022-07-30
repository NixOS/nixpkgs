{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, libiconv
, libgit2
, pkg-config
, nixosTests
, Security
, Foundation
, Cocoa
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "starship";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IujaGyAGYlBb4efaRb13rsPSD2gWAg5UgG10iMp9iQE=";
  };

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ libgit2 ] ++ lib.optionals stdenv.isDarwin [ libiconv Security Foundation Cocoa ];

  buildNoDefaultFeatures = true;
  # the "notify" feature is currently broken on darwin
  buildFeatures = if stdenv.isDarwin then [ "battery" ] else [ "default" ];

  shells = ["bash" "fish" "zsh"];
  outputs = ["out"] ++ (map (sh:"promptInit_${sh}") shells);
  postInstall = lib.concatMapStrings (sh: ''
  
    STARSHIP_CACHE=$TMPDIR $out/bin/starship completions ${sh} > starship.${sh}
    installShellCompletion starship.${sh}
    (
      echo 'if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then'
      $out/bin/starship init ${sh}
      echo fi
    ) > $promptInit_${sh}

  '') shells;

  cargoSha256 = "sha256-HrSMNNrldwb6LMMuxdQ84iY+/o5L2qwe+Vz3ekQt1YQ=";

  preCheck = ''
    HOME=$TMPDIR
  '';

  passthru.tests = {
    inherit (nixosTests) starship;
  };

  meta = with lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras danth davidtwco Br1ght0ne Frostman marsam ];
  };
}
