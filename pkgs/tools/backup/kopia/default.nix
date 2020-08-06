{ lib, buildGoModule, fetchFromGitHub, coreutils }:

buildGoModule rec {
  pname = "kopia";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1s74wa2r6nzrbp1f1bcbypwggishwwvpnwnqzs8gncz7dsa44zj4";
  };

  vendorSha256 = "11az7zgwzbcx4dknwqiwmdbrbkdzhpwzqnyk8vw9mkbda0xaif3k";
  subPackages = [ "." ];

  postConfigure = ''
    # make 'vendor' writable
    cp -L -r vendor tmp-vendor
    rm -rf vendor
    mv tmp-vendor vendor

    # speakeasy hardcodes /bin/stty https://github.com/bgentry/speakeasy/issues/22
    substituteInPlace vendor/github.com/bgentry/speakeasy/speakeasy_unix.go \
      --replace "/bin/stty" "${coreutils}/bin/stty"
  '';

  meta = with lib; {
    homepage = "https://kopia.io";
    description = "Cross-platform backup tool with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.bbigras ];
  };
}
