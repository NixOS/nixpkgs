{ lib, stdenv
, libXScrnSaver
, makeWrapper
, fetchurl
, wrapGAppsHook
, glib
, gtk3
, unzip
, atomEnv
, libuuid
, at-spi2-atk
, at-spi2-core
, libdrm
, mesa
, libxkbcommon
, libappindicator-gtk3
, libxshmfence
, libglvnd
}@args:

let
  mkElectron = import ./generic.nix args;
in
rec {

  electron = electron_21;

  electron_17 = mkElectron "17.4.1" {
    armv7l-linux = "d1329468cb21039fb5b503fc813381f9be4d43422383b44f859b450be0e4200c";
    aarch64-linux = "70d29bca5f884753341a11b0445ccf159c0f43dfae16eb60c53946582c3128b0";
    x86_64-linux = "f9437a86947c418d92eabea14b268dcc4a5dde74cc6927530c1e9195e4aeddf8";
    i686-linux = "436f44d778acc41a4a07cc4ee23ab861e2c4d72e4b1335e3c4ccfd4855deb594";
    x86_64-darwin = "0357bcf841bc246d01df8b838fa5de9856bd48f4fa6b2b4f3053ba3db492e54b";
    aarch64-darwin = "827f6ecb7bc4d4ed88eb22e1b02615465ad13ace918d294c873a67a34c207dcf";
    headers = "064qnwv6gqn502r1cv7vi6ahvgyxcqq7mv0rmk2bxfpkr5x6hgmh";
  };

  electron_18 = mkElectron "18.1.0" {
    armv7l-linux = "c2296f3f68938aab4cef07b747d2dd28973625b6717163b9c51fbcf1509fd8ff";
    aarch64-linux = "13bd4998d0d86ccf4cb87d11f9581d5a6063b4585fc4828e130054527dfb9179";
    x86_64-linux = "7f95069d58e6843e6ae2b8f02619d4dcef7db4c35bd6e90b903268d83b939fba";
    i686-linux = "e952d06b3828695636de522e3af8140543ecbe02d7351dd002b0ffb9e2a09705";
    x86_64-darwin = "24dd64a66b820c9553c5e5570907da6c98e808d33fac98072b9c2a8f1659cb14";
    aarch64-darwin = "97adf13306c9b3b304d3e9ddf68f5f7fb9b79c9a1342114e3671182f3cc9e808";
    headers = "0gl30q2igr9c8sjlhyj5w57dm5navpkas5hnz9yl7sasbx66v10v";
  };

  electron_19 = mkElectron "19.0.7" {
    armv7l-linux = "d6a6d2d7c0d658695783137d032a50f20843cdfe6582ef985451d741eef4dd32";
    aarch64-linux = "58685d21bb92c2667d20063ab12aabc2e5c2518f3eda84e98a0fa2306456ce57";
    x86_64-linux = "a4c20a068c54c238ae8c440ab8f46d39eda4168d6aa8cffcaae406800b539983";
    x86_64-darwin = "2709dd94e22ecfc8e7de0c7a7009160ed79e95ba91618c7307e24c26a33e978b";
    aarch64-darwin = "f9042bce83fe8446e22f6885285dd5fc2dca048d0b89cbf7f326a46102ffc440";
    headers = "09dbx4qh0rgp5mdm6srz6fgx12zq6b9jqq1k6l3gzyvwigi3wny1";
  };

  electron_20 = mkElectron "20.1.3" {
    armv7l-linux = "99710a57c55d95b540f4c3568da2a7caccb7f91da23b530c8c40db5ac861ab24";
    aarch64-linux = "8f39562f20210d7cdedbb063683d632df442c8553f62104c7d676121f3d9a357";
    x86_64-linux = "219fb6f01305669f78cf1881d257e3cc48e5563330338516f8b6592d85fdb4a3";
    x86_64-darwin = "134714291dcbecbf10cbc27c490a6501e2810bd4147a74f3b2671503445f2ce8";
    aarch64-darwin = "a09f83442f1e9f4b1edc07445a1dca73d9597529b23d62731eaa3fa0488f4ab0";
    headers = "11cv0p52864k4knwlwakiq8v6rxdv3iz6kvwhn0w8mpap2h5pzii";
  };

  electron_21 = mkElectron "21.2.1" {
    armv7l-linux = "1f68ffacbcd0086c5bcbc726e3a0bd707b03acdf5c82d5cc44666b6e9a0d8a78";
    aarch64-linux = "78c1c6ecf5959e67fa6c67d82dc7deb170bc10d34d45265d6e972dd5b996bcb9";
    x86_64-linux = "d8aa2ea7b1a1421ca245ced1a9bdd77408bf7aee6f75c19d5e0e73dc120442b7";
    x86_64-darwin = "f20c0be6cb51bad1bb591ec1116be622e631cbc89876b2258c55579bbe52de30";
    aarch64-darwin = "2ac1bde2bbb4a265422e00eb5e1d81302b0c349b2db6e7bf1ee6f236a68b3d53";
    headers = "1c1g6jc0p678d5sr2w4irhfkj02vm4kb92b7cvimz8an0jwy58x7";
  };
}
