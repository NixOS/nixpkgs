{ fetchDenoDeps }:
{
  fetchDenoDeps-e2e-tests = {
    just-jsr-linux = fetchDenoDeps {
      globalArgs.pname = "test-denoDeps-just-jsr-linux";
      denoLock = ./just-jsr/deno.lock;
      hash = "sha256-CV/2kYxYYA1g5/dwSKiC4h1F2+6seTItTLBYQoSt0og=";
    };
    with-https-linux = fetchDenoDeps {
      globalArgs.pname = "test-denoDeps-with-https-linux";
      denoLock = ./with-https/deno.lock;
      hash = "sha256-O3P2x8kkD92AdbuRIUNp+OJN54ymRhSS1Xscu8dWIGY=";
    };
    with-https-and-npm-linux = fetchDenoDeps {
      globalArgs.pname = "test-denoDeps-with-https-and-npm-linux";
      denoLock = ./with-https-and-npm/deno.lock;
      hash = "sha256-TrYrURHG57nGLTSrTEqOGIkQXcpP81NDrIvGVtgwNv0=";
    };
  };
}
