{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cliphist";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CZW7dhOd7E74VNjnvhxvSSUZQtbkGi4uRUM9YQCuJZw=";
  };

  vendorSha256 = "sha256-UrKSDvskGwHjwkb/fjvaJZ8xXFD98BFeSJxwJpc8A+M=";

  meta = with lib; {
    description = "Wayland clipboard manager";
    homepage = "https://github.com/sentriz/cliphist";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
  };
}
