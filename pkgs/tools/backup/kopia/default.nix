{ lib, buildGoModule, fetchFromGitHub, coreutils }:

buildGoModule rec {
  pname = "kopia";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1ngm0vbx6ryks68bp0zarvncc36gbpkkqavxb3sfph9p959b9hif";
  };

  vendorSha256 = "07p2ka5rbasrgjfd4k2jn0ffshjp39kilz9b714ykyi1qflczr9b";

  doCheck = false;

  subPackages = [ "." ];

  buildFlagsArray = ''
    -ldflags=
       -X github.com/kopia/kopia/repo.BuildVersion=${version}
       -X github.com/kopia/kopia/repo.BuildInfo=${src.rev}
  '';

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
    license = licenses.asl20;
    maintainers = [ maintainers.bbigras ];
  };
}
