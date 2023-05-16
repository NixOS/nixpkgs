{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "cloudmonkey";
<<<<<<< HEAD
  version = "6.3.0";
=======
  version = "6.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "apache";
    repo = "cloudstack-cloudmonkey";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-FoouZ2udtZ68W5p32Svr8yAn0oBdWMupn1LEzqY04Oc=";
  };

  vendorHash = null;
=======
    sha256 = "sha256-C9e2KsnoggjWZp8gx757MbFdGxmfh+TtAd+luS3ycHU=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "CLI for Apache CloudStack";
    homepage = "https://github.com/apache/cloudstack-cloudmonkey";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
    mainProgram = "cloudstack-cloudmonkey";
  };

}
