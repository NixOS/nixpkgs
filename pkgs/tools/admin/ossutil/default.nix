{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  version = "1.7.6";
  pname = "ossutil";

  src = fetchFromGitHub {
    owner = "aliyun";
    repo = "ossutil";
    rev = version;
    sha256 = "1hkdk0hidnm7vz320i7s4z7jngx2j70acc93agii2b3r2bb91l3d";
  };

  # this patch is required to add go mods to fetch dependencies
  patches = [
    (fetchpatch {
      url = "https://github.com/aliyun/ossutil/commit/64067e979fb24ffb198a0c4eca718e81b63f514e.patch";
      sha256 = "2pn0BcbNNL+iMema54LRpG/ca5kyDugLIZQ/TMhYG/8=";
    })
  ];

  vendorSha256 = "lem9Jg4Ywv3qcIwhiZHNi1VH5HxxNr6mnefOLCzPL70=";

  # don't run tests as they require secret access keys that only travis has
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/aliyun/ossutil";
    description = "A user friendly command line tool to access Alibaba Cloud OSS";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
