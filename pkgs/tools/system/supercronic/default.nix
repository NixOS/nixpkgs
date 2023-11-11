{ lib
, buildGoModule
, fetchFromGitHub
, python3
, bash
, coreutils
}:

buildGoModule rec {
  pname = "supercronic";
  version = "0.2.27";

  src = fetchFromGitHub {
    owner = "aptible";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sgKvE8Ze2qKPgdaAwN1sB0wX7k5VRx8+llkT54xXvrM=";
  };

  vendorHash = "sha256-j1iduvu+dKmhvPN8pe50fGQU5cC9N3gfoMh9gSQDbf8=";

  excludedPackages = [ "cronexpr/cronexpr" ];

  nativeCheckInputs = [ python3 bash coreutils ];

  postConfigure = ''
    # There are tests that set the shell to various paths
    substituteInPlace cron/cron_test.go --replace /bin/sh ${bash}/bin/sh
    substituteInPlace cron/cron_test.go --replace /bin/false ${coreutils}/bin/false
  '';

  meta = with lib; {
    description = "Cron tool designed for use in containers";
    homepage = "https://github.com/aptible/supercronic";
    license = licenses.mit;
    maintainers = with maintainers; [ nasageek ];
  };
}
