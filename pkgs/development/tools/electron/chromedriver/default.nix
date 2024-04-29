{ callPackage }:

let
  mkChromedriver = callPackage ./generic.nix { };
in
rec {
  electron-chromedriver = electron-chromedriver_30;

  electron-chromedriver_30 = mkChromedriver "30.0.9" {
    armv7l-linux = "b441b3198e9b6fa846c2b292152f1fb6cd1124a5a3574a1992372274a4b6a616";
    aarch64-linux = "a1e1f1067fe5e0bc520305e06fcdbf9459c1b7d72abbb7ecee8cb68e2f878af4";
    x86_64-linux = "f9e1fc97c3f21808db3cd92e03197eafc338d0f6e83a314d6f22e075e4b31db0";
    x86_64-darwin = "ebfd702225cf34db6f9cca51915758b442c939e73de961f14987f48c49085c53";
    aarch64-darwin = "7ba268d6700b006af61288ba40a97b59db2fcd8bda98826a704d15ed69311b0f";
  };

  electron-chromedriver_29 = mkChromedriver "29.4.2" {
    armv7l-linux = "e7bc85b47ec47f282a6d198f33c656618f9011366f47bb04fd31cef331691c8b";
    aarch64-linux = "b501dac3cd694a879a82f65d6a15047ff417c3b5d70107ee38973f4d16477ea1";
    x86_64-linux = "e612ae9910bfd004ced13cdef0dda9e49d699c69ac18f04900b1129b98d41b23";
    x86_64-darwin = "79d99b273e46b09cd21f09bf066aecaec50650b79e3832a13bf6365e43dd6a1c";
    aarch64-darwin = "4a362dbf6e6553a7aea56d00beb34e8d7ac1a2f2655cb681633878ea36889d38";
  };
}
