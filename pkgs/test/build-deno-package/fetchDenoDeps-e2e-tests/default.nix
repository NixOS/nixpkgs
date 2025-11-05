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
      hash = "sha256-CV/2kYxYYA1g5/dwSKiC4h1F2+6seTItTLBYQoSt0og=";
    };
    with-https-linux = fetchDenoDeps {
      name = "test-deno-fetch-${fetcherSrc}";
      denoLock = ./with-https/deno.lock;
      hash = "sha256-O3P2x8kkD92AdbuRIUNp+OJN54ymRhSS1Xscu8dWIGY=";
    };
    with-https-and-npm-linux = fetchDenoDeps {
      name = "test-deno-fetch-${fetcherSrc}";
      denoLock = ./with-https-and-npm/deno.lock;
      hash = "sha256-TrYrURHG57nGLTSrTEqOGIkQXcpP81NDrIvGVtgwNv0=";
    };
  };
}
