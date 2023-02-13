{ lib, buildGoModule, fetchFromGitHub, runCommand }:

buildGoModule rec {
  pname = "elvish";
  version = "0.18.0";

  subPackages = [ "cmd/elvish" ];

  ldflags = [ "-s" "-w" "-X src.elv.sh/pkg/buildinfo.Version==${version}" "-X src.elv.sh/pkg/buildinfo.Reproducible=true" ];

  src = fetchFromGitHub {
    owner = "elves";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AyTkJiNebpq17vdPluwJBztivezd+c1KAdWFTYYDIFE=";
  };

  vendorSha256 = "sha256-iuklI7XEQUgZ2ObYRROxyiccZ1JkajK5OJA7hIcpRZQ=";

  strictDeps = true;
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out${passthru.shellPath} -c "
      fn expect {|key expected|
        var actual = \$buildinfo[\$key]
        if (not-eq \$actual \$expected) {
          fail '\$buildinfo['\$key']: expected '(to-string \$expected)', got '(to-string \$actual)
        }
      }

      expect version ${version}
      expect reproducible \$true
    "

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A friendly and expressive command shell";
    longDescription = ''
      Elvish is a friendly interactive shell and an expressive programming
      language. It runs on Linux, BSDs, macOS and Windows. Despite its pre-1.0
      status, it is already suitable for most daily interactive use.
    '';
    homepage = "https://elv.sh/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra AndersonTorres ];
  };

  passthru.shellPath = "/bin/elvish";
}
