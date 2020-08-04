{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "mage";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "magefile";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c77xgz2bz4j9sh9v7f49iqyamc4lvvldcmn6v50hk98s9193gbf";
  };

  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  buildFlagsArray = [
    "-ldflags="
    "-X github.com/magefile/mage/mage.commitHash=v${version}"
    "-X github.com/magefile/mage/mage.gitTag=v${version}"
    "-X github.com/magefile/mage/mage.timestamp=1970-01-01T00:00:00Z"
  ];

  meta = with lib; {
    description = "A Make/Rake-like Build Tool Using Go";
    homepage = "https://magefile.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop ];
    platforms = platforms.all;
  };
}
