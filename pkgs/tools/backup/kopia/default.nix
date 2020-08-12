{ lib, buildGoModule, fetchFromGitHub, coreutils }:

buildGoModule rec {
  pname = "kopia";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0jxl2zq3s3czz52ndq7zbj8liij0519745pbcqaj42x851c1p6mj";
  };

  vendorSha256 = "1npxr7gp59xv38zdx1diilfxij6lb0cmvsnzvjx6n8g0326gf2ii";

  doCheck = false;

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
