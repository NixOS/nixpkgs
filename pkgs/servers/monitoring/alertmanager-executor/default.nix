{
  lib,
  nixosTests,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "alertmanager-executor";
  version = "unstable-2022-02-04";

  src = fetchFromGitHub {
    owner = "imgix";
    repo = "prometheus-am-executor";
    rev = "d43ae740ade7641258cc13c4ef2b9c19e7c63fc2";
    sha256 = "sha256-TJIh+mNBTOauheIlC4O6FI5xBzmcXgMyVA+zUFyYY/4=";
  };

  vendorSha256 = "sha256-NUu97fpCw1YPyRyHq4+sX9IiSHb3ALlx8yo4zvppP/A=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r $src/examples $out/share/
  '';

  passthru.tests.alertmanager-executor = nixosTests.alertmanager-executor;

  meta = with lib; {
    description = "Execute command based on Prometheus alerts";
    longDescription = ''
      The prometheus-am-executor is a HTTP server that receives alerts from the
      Prometheus Alertmanager and executes a given command with alert details
      set as environment variables.
    '';
    homepage = "https://github.com/imgix/prometheus-am-executor";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mmilata ];
    platforms = platforms.linux;
  };
}
