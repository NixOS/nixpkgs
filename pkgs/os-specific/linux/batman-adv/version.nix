{
  version = "2023.1";

  sha256 = {
    batman-adv = lib.fakeSha256;
    alfred = lib.fakeSha256;
    batctl = lib.fakeSha256;
  };
}
