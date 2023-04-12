{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, nixosTests
, openssh
, fetchpatch
}:
buildGoModule rec {
  pname = "zrepl";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "zrepl";
    repo = "zrepl";
    rev = "v${version}";
    sha256 = "sha256-XazwuaAzgTuKITF1mYihsNwkIKi5fvZrCvlCDKwxj4U=";
  };

  vendorSha256 = "sha256-75fGejR7eiECsm1j3yIU1lAWaW9GrorrVnv8JEzkAtU=";

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
