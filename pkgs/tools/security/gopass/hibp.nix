{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "gopass-hibp";
<<<<<<< HEAD
  version = "1.15.7";
=======
  version = "1.15.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-hibp";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-525e2LXQ/Ldrqhxqndwpdo2HeS4xRkbPzfwvWeiEayE=";
  };

  vendorHash = "sha256-jfqxl21euOtOvt+RltVlSjca2o8VuLtWHgpnW4ve5JM=";
=======
    hash = "sha256-BHMhQqaYM0WfCzvDo7X1GEVNv44zEw2KeA9jhF7RgC4=";
  };

  vendorHash = "sha256-Y6BMzSRzbORIbebfP+ptIswyOclM1bs1zPmLpqko//4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-hibp \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Gopass haveibeenpwnd.com integration";
<<<<<<< HEAD
    homepage = "https://github.com/gopasspw/gopass-hibp";
    changelog = "https://github.com/gopasspw/gopass-hibp/blob/v${version}/CHANGELOG.md";
=======
    homepage = "https://www.gopass.pw/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
