{ lib, buildGoModule, fetchFromGitHub, coreutils }:

buildGoModule rec {
  pname = "kopia";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1mq3vx8vrvvh3jrdqhrkbnnfkjsjw5ipw15d0602i1x05fxah4v4";
  };

  vendorSha256 = "1npxr7gp59xv38zdx1diilfxij6lb0cmvsnzvjx6n8g0326gf2ii";

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
