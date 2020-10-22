{ lib, buildGoModule, fetchFromGitHub, coreutils }:

buildGoModule rec {
  pname = "kopia";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1dnk764y71c9k9nghn9q06f2zz9igsvm4z826azil2d58h5d06j6";
  };

  vendorSha256 = "1mnhq6kn0pn67l55a9k6irmjlprr295218nms3klsk2720syzdwq";

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
    chmod -R u+w tmp-vendor
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
