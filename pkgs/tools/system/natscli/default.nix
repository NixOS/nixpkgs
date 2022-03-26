{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.0.30";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+WvJWHRQr5wYV9TG5e379trBO2Gwy0/4bAEJNwDun7s=";
  };

  vendorSha256 = "sha256-IHDJp+cjukX916dvffpv4Wit9kmuY101fasN+ChMxWQ=";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
