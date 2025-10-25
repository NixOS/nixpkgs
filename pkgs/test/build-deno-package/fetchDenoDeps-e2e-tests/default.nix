{ fetchDenoDeps }:
{
  fetchDenoDeps-e2e-tests = {
    just-jsr-linux = fetchDenoDeps {
      name = "test-deno-fetch";
      denoLock = ./just-jsr/deno.lock;
      hash = "sha256-yjZ7XCjmjAiCL00XrbwRS6UDTNk72kz9uvv5eborq1I=";
    };
    with-https-linux = fetchDenoDeps {
      name = "test-deno-fetch";
      denoLock = ./with-https/deno.lock;
      hash = "sha256-Ktjoqz1c7FzhXbez2xtqX6hjFnvAFtXu7YxaSRGtTFs=";
    };
    with-https-and-npm-linux = fetchDenoDeps {
      name = "test-deno-fetch";
      denoLock = ./with-https-and-npm/deno.lock;
      hash = "sha256-VmwJbCXY8du2zkIQCySxwxMBitOuWQO8HQPRXVUiDLg=";
    };
  };
}
