{ lib
, buildGoModule
, fetchFromSourcehut
}:

buildGoModule rec {
  pname = "wlhax";
  version = "unstable-2022-04-17";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "wlhax";
    rev = "a8e83a4dc1c0c4ebf7bd2f3103abae2d148941f9";
    sha256 = "sha256-1sCS4HKmegiwjdCF+vYH/yyBFpxblZeld6aQxflCm8Q=";
  };

  vendorSha256 = "sha256-1zAKVg+l1frdE+PYgc0sjjQ+v/OJa9b7leikPwbDl3o=";

  meta = with lib; {
    description = "Wayland proxy that monitors and displays various application state, such as the current surface tree, in a nice little TUI.";
    homepage = "https://git.sr.ht/~kennylevinsen/wlhax";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ emantor ];
    mainProgram = "wl_hax";
  };
}
