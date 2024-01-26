{ lib
, buildGoModule
, fetchFromGitHub
, python3
, bash
, coreutils
}:

buildGoModule rec {
  pname = "supercronic";
  version = "0.2.29";

  src = fetchFromGitHub {
    owner = "aptible";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cYKVeWZEjWV5j68aTpBOE/z+5QcMBh5ovyXoV/u80o4=";
  };

  vendorHash = "sha256-uQFceysbRdcSaFvdfdFcJX6yzPWE26YYiVzAEISQeCc=";

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
    mainProgram = "supercronic";
  };
}
