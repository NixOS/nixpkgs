{ buildPythonApplication, lib, minijail, minijail-tools, testVersion }:

buildPythonApplication {
  pname = "minijail-tools";
  inherit (minijail) version src;

  passthru.tests.version = testVersion { package = minijail-tools; };

  meta = with lib; {
    homepage = "https://android.googlesource.com/platform/external/minijail/+/refs/heads/master/tools/";
    description = "A set of tools for minijail";
    license = licenses.asl20;
    inherit (minijail.meta) maintainers platforms;
  };
}
