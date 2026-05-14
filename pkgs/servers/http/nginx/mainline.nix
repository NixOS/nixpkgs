{ callPackage, fetchpatch, ... }@args:

callPackage ./generic.nix args {
  version = "1.29.7";
  hash = "sha256-Zz+PuMCWHET72UENYWGDFFNgm0QGPT8pSCU/wrVpITk=";
  extraPatches = [
    (fetchpatch {
      name = "CVE-2026-40460.patch";
      url = "https://github.com/nginx/nginx/commit/f37ec3e5d4f527e52ed5b25951ad8aa7d1ff6266.patch";
      hash = "sha256-++hYEzMUkl3mbBMaffR2LQTYMxOR/YziNkYCVyhw2Qg=";
    })
    (fetchpatch {
      name = "CVE-2026-40701.patch";
      url = "https://github.com/nginx/nginx/commit/71841dcedfdf46048ef5e25413fdf97a66957913.patch";
      hash = "sha256-FzNZpEwIj76r5dpqEP6TgpSc1ywcW7ZOEQpFpwI/YZw=";
    })
    (fetchpatch {
      # required for CVE-2026-42926 to apply
      name = "proxy-fix-keepalive-http2.patch";
      url = "https://github.com/nginx/nginx/commit/ce3362cfd5c3e1434a6151cfa585b89114389da7.patch";
      hash = "sha256-OK2w69bsEMVh9F6W7GAEraufenvQ1fb6nZlnRw3c/z4=";
    })
    (fetchpatch {
      name = "CVE-2026-42926.patch";
      url = "https://github.com/nginx/nginx/commit/a0e742944db64d8a547cc2e7a0ba4c2e85cd4b98.patch";
      hash = "sha256-37zS+VynsP5Fj9ECBUbsQcH6O9T1tlpSvYXLrCZrXFY=";
    })
    (fetchpatch {
      name = "CVE-2026-42934.patch";
      url = "https://github.com/nginx/nginx/commit/696a7f1b9198d576e6a59c1655b746fbf06561cf.patch";
      hash = "sha256-/vjyEGysPv5VK4TZmk/gtIg9Zc5ogUXMwpBfBwe55Bc=";
    })
    (fetchpatch {
      name = "CVE-2026-42945.patch";
      url = "https://github.com/nginx/nginx/commit/2046b45aa0c6e712c216b9075886f3f26e9b4ca9.patch";
      hash = "sha256-VK9CXgrCIqORsaRivTZBmkoLyQhbZ07ss6nAbLNvfJM=";
    })
    (fetchpatch {
      name = "CVE-2026-42946.patch";
      url = "https://github.com/nginx/nginx/commit/baef7fdac28e4e1fe26509b50b8d15603393e28e.patch";
      hash = "sha256-Z1naMxxiVuDbUcvX3PiIK4CMuSSpUyzPqjix9GTwHmk=";
    })
    (fetchpatch {
      # It's unclear whether this is part of the CVE fix, but is released at the same time so it's likely
      # a good idea to pick it too.
      name = "CVE-2026-42946-part-2.patch";
      url = "https://github.com/nginx/nginx/commit/39d7d0ba0799fcff6baee52b6525f45739593cfd.patch";
      hash = "sha256-6PwV0iz4kQGGBwVk9129aH+TFzbSx3QSVpp22AoKQY4=";
    })
  ];
}
