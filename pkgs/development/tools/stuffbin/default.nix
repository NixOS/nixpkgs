{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stuffbin";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "knadh";
    repo = pname;
    rev = "v${version}";
    sha256 = "12nx1ymhbz2vkc8bm4dbl3j0ksgv86rg330grh5l6afv3qvb3g9k";
  };

  subPackages = [ "stuffbin" ];

  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  meta = with lib; {
    homepage = "https://github.com/knadh/stuffbin";
    description = "Compress and embed static files and assets into Go binaries and access them with a virtual file system in production";
    maintainers = with maintainers; [ RaghavSood ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
