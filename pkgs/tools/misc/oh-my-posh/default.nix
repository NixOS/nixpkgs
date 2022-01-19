{ stdenv
, lib
, fetchFromGitHub
, buildGoModule
, runCommand
, oh-my-posh
}:

buildGoModule rec {
  pname = "oh-my-posh";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "JanDeDobbeleer";
    repo = "oh-my-posh";
    rev = "v${version}";
    sha256 = "b8+G7LOHHz65rfhBL+IxwJhvA2JJc49gfEJboK0cFpc=";
  };
  modRoot = "./src";

  vendorSha256 = "u5rpXEEKCq+FLyM9/LnjfGH5cYDdhYkkGeesNmk5c1U=";

  ldflags = [
    "-s" "-w"
    "-X main.Version=${version}"
  ];

  passthru.tests = {
    test-version = runCommand "${pname}-test-version" {} ''
      version=$(${oh-my-posh}/bin/oh-my-posh --version)
      [ "$version" = '${version}' ]
      touch $out
    '';
    # To generate the expected-prompt.out, add `echo $prompt; exit 1` after the
    # line `prompt=$(...)`.
    # Then execute the test and in the error message, look for the line
    #   For full logs, run 'nix log /nix/store/<HASH>-oh-my-posh-test-parse-config.drv'
    # Now pipe the output of this command to the `.out` file:
    #   $ nix log /nix/store/<HASH>-oh-my-posh-test-parse-config.drv > test/expected-prompt.out
    test-parse-config = runCommand "${pname}-test-parse-config" {} ''
      config='${./test/themes/agnoster.omp.json}'
      prompt=$(${oh-my-posh}/bin/oh-my-posh -shell sh --config "$config")
      expected=$(cat '${./test/expected-prompt.agnoster.out}')
      [ "$prompt" = "$expected" ]
      touch $out
    '';
  };

  meta = with lib; {
    homepage = "https://ohmyposh.dev/";
    description = "Cross platform, highly customizable and extensible prompt theme engine for any shell";
    longDescription = ''
      Features:

      - Shell independent
      - Git status indications
      - Failed command indication
      - Admin indication
      - Current session indications
      - Language info
      - Shell info
      - Configurable
      - Fast
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ x3ro ];
    platforms = platforms.linux;
  };
}
