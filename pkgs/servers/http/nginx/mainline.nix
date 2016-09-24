{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.11.4";
  sha256 = "0fvb09ycxz3xnyynav6ybj6miwh9kv8jcb2vzrmvqhzn8cgiq8h6";
})
