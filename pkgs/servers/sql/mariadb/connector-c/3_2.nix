{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.2.5";
  sha256 = "0w0fimdiiqrrm012iflz8l4rnafryq7y0qqijzxn7nwzxhm9jsr9";
})
