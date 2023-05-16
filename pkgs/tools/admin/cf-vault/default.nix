{buildGoModule, fetchFromGitHub, lib}:
buildGoModule rec {
  pname = "cf-vault";
<<<<<<< HEAD
  version = "0.0.15";
=======
  version = "0.0.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-+6+I69LRCoU35lTrM8cZnzJsHB9SIr6OQKaiRFo7aW4=";
  };

  vendorHash = "sha256-oNLGHV0NFYAU1pHQWeCmegonkEtMtGts0uWZWPnLVuY=";
=======
    sha256 = "sha256-wW/CSF+DexrdmOvp3BpyBmltOyF4TBTW3OXwjdqfaR4=";
  };

  vendorSha256 = "sha256-H44YCoay/dVL22YhMy2AT/Jageu0pM9IS0SWPp9E4F8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = ''
      A tool for managing your Cloudflare credentials, securely..
    '';
    homepage = "https://github.com/jacobbednarz/cf-vault/";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
