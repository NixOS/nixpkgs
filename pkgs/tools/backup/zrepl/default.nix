{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, nixosTests
, openssh
}:
buildGoModule rec {
  pname = "zrepl";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "zrepl";
    repo = "zrepl";
    rev = "v${version}";
    sha256 = "4q/wwlF11HPDS2lTXUizJ3RFQ9sX5qNnWZUKAgnvDiE=";
  };

  vendorSha256 = "xToq9pKAxxknh4kE8S3uUg5ySPMbJkLftkMhofNxotc=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [ "-s" "-w" "-X github.com/zrepl/zrepl/version.zreplVersion=${version}" ];

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    substitute dist/systemd/zrepl.service $out/lib/systemd/system/zrepl.service \
      --replace /usr/local/bin/zrepl $out/bin/zrepl

    wrapProgram $out/bin/zrepl \
      --prefix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  passthru.tests = {
    inherit (nixosTests) zrepl;
  };

  meta = with lib; {
    homepage = "https://zrepl.github.io/";
    description = "A one-stop, integrated solution for ZFS replication";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ cole-h danderson mdlayher ];
  };
}
