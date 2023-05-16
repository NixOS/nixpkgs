{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "swego";
<<<<<<< HEAD
  version = "1.0";
=======
  version = "0.98";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nodauf";
    repo = "Swego";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-OlaNDXKaIim5n0niqYIpRliVo7lse76vNxPKF6B6yF0=";
  };

  vendorHash = "sha256-N4HDngQFNCzQ74W52R0khetN6+J7npvBC/bYZBAgLB4=";
=======
    sha256 = "sha256-fS1mrB4379hnnkLMkpKqV2QB680t5T0QEqsvqOp9pzY=";
  };

  vendorSha256 = "sha256-N4HDngQFNCzQ74W52R0khetN6+J7npvBC/bYZBAgLB4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    mv $out/bin/src $out/bin/$pname
  '';

  meta = with lib; {
    description = "Simple Webserver in Golang";
    longDescription = ''
      Swiss army knife Webserver in Golang. Similar to the Python
      SimpleHTTPServer but with many features.
    '';
    homepage = "https://github.com/nodauf/Swego";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
    # darwin crashes with:
    # src/controllers/parsingArgs.go:130:4: undefined: PrintEmbeddedFiles
    broken = stdenv.isDarwin;
  };
}
