{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rdap";
<<<<<<< HEAD
  version = "0.9.1";
  vendorHash = "sha256-8b1EAnR8PkEAw9yLBqPKFeANJit0OCJG+fssAGR/iTk=";
=======
  version = "2019-10-17";
  vendorSha256 = "sha256-j7sE62NqbN8UrU1mM9WYGYu/tkqw56sNKQ125QQXAmo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "openrdap";
    repo = "rdap";
<<<<<<< HEAD
    rev = "v${version}";
    sha256 = "sha256-FiaUyhiwKXZ3xnFPmdxb8bpbm5eRRFNDL3duOGDnc/A=";
=======
    rev = "af93e7ef17b78dee3e346814731377d5ef7b89f3";
    sha256 = "sha256-7MR4izJommdvxDZSRxguwqJWu6KXw/X73RJxSmUD7oQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  doCheck = false;

  ldflags = [ "-s" "-w" "-X \"github.com/openrdap/rdap.version=OpenRDAP ${version}\"" ];

  meta = with lib; {
    homepage = "https://www.openrdap.org/";
    description = "Command line client for the Registration Data Access Protocol (RDAP)";
    license = licenses.mit;
    maintainers = with maintainers; [ sebastianblunt ];
  };
}
