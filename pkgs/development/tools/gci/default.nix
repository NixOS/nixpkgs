{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gci";
<<<<<<< HEAD
  version = "0.11.1";
=======
  version = "0.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "daixiang0";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-qNkSAbVhX4P+DqCtxXSnxYjZwq/nMYsDpEif+q1oTIA=";
=======
    sha256 = "sha256-/YR61lovuYw+GEeXIgvyPbesz2epmQVmSLWjWwKT4Ag=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-g7htGfU6C2rzfu8hAn6SGr0ZRwB8ZzSf9CgHYmdupE8=";

  meta = with lib; {
    description = "Controls golang package import order and makes it always deterministic";
    homepage = "https://github.com/daixiang0/gci";
    license = licenses.bsd3;
    maintainers = with maintainers; [krostar];
  };
}
