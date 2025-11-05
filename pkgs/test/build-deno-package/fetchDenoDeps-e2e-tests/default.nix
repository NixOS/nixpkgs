{ fetchDenoDeps, fetch-deno-deps-scripts }:
let
  # to invalidate tests when source changed
  fetcherSrc = "${fetch-deno-deps-scripts.deno}";
in
{
  fetchDenoDeps-e2e-tests = {
    just-jsr-linux = fetchDenoDeps {
      name = "test-deno-fetch-${fetcherSrc}";
      denoLock = ./just-jsr/deno.lock;
      hash = "sha256-e3PiKCDZo6b+4BsS087cvKwxpSDu2RD5fkhxOLt89uE=";
    };
    with-https-linux = fetchDenoDeps {
      name = "test-deno-fetch-${fetcherSrc}";
      denoLock = ./with-https/deno.lock;
      hash = "sha256-vhM+WIH28FA+W3wW496UZ+vxWkOK7c9Xlk9t8fMAXco=";
    };
    with-https-and-npm-linux = fetchDenoDeps {
      name = "test-deno-fetch-${fetcherSrc}";
      denoLock = ./with-https-and-npm/deno.lock;
      hash = "sha256-AeGnHTQHIiK8DbITmUPMqRpfyrEplSYfgrgvXQqRCXg=";
    };
  };
}
