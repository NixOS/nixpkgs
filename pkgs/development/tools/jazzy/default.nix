{ lib, bundlerApp, ruby }:

bundlerApp rec {
  inherit ruby;
  pname = "jazzy";
  gemdir = ./.;
  exes = [ "jazzy" ];

  passthru.updateScript = ./update;

  meta = with lib; {
    description     = "A command-line utility that generates documentation for Swift or Objective-C";
    homepage        = https://github.com/realm/jazzy;
    license         = licenses.mit;
    platforms       = platforms.darwin;
    maintainers     = with maintainers; [
      peterromfeldhk
      lilyball
    ];
  };
}
