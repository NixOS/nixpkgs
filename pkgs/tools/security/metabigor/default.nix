{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "metabigor";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "j3ssie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-T1P+jAAsKObKRaoxH8c/DMEfXtmSrvnDd5Y3ocKcCSc=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-V+72l2TvhEWgDg7kvn5OOjYcyEgWGLgTGnt58Bu+AEQ=";
=======
  vendorSha256 = "sha256-V+72l2TvhEWgDg7kvn5OOjYcyEgWGLgTGnt58Bu+AEQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Disabled for now as there are some failures ("undefined:")
  doCheck = false;

  meta = with lib; {
    description = "Tool to perform OSINT tasks";
    homepage = "https://github.com/j3ssie/metabigor";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
