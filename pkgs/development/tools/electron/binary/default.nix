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
, wayland
}@args:

let
  mkElectron = import ./generic.nix args;
in
rec {

<<<<<<< HEAD
  electron-bin = electron_26-bin;
=======
  electron-bin = electron_24-bin;

  electron_9-bin = mkElectron "9.4.4" {
    x86_64-linux = "781d6ca834d415c71078e1c2c198faba926d6fce19e31448bbf4450869135450";
    x86_64-darwin = "f41c0bf874ddbba00c3d6989d07f74155a236e2d5a3eaf3d1d19ef8d3eb2256c";
    i686-linux = "40e37f8f908a81c9fac1073fe22309cd6df2d68e685f83274c6d2f0959004187";
    armv7l-linux = "2dfe3e21d30526688cc3d3215d06dfddca597a2cb62ff0c9d0d5f33d3e464a33";
    aarch64-linux = "f1145e9a1feb5f2955e5f5565962423ac3c52ffe45ccc3b96c6ca485fa35bf27";
    headers = "0yx8mkrm15ha977hzh7g2sc5fab9sdvlk1bk3yxignhxrqqbw885";
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  electron_10-bin = mkElectron "10.4.7" {
    x86_64-linux = "e3ea75fcedce588c6b59cfa3a6e46ba67b789e14dc2e5b9dfe1ddf3f82b0f995";
    x86_64-darwin = "8f01e020563b7fce68dc2e3d4bbf419320d13b088e89eb64f9645e9d73ad88fb";
    i686-linux = "dd7fde9b3993538333ec701101554050b27d0b680196d0883ab563e8e696fc79";
    armv7l-linux = "56f11ed14f8a620650d31c21ebd095ce59ef4286c98276802b18f9cc85560ddd";
    aarch64-linux = "0550584518c8e98fe1113706c10fd7456ec519f7aa6867fbff17c8913327d758";
    headers = "01x6a0r2jawjpl09ixgzap3g0z6znj34hsnnhzanavkbds0ri4k6";
  };

  electron_11-bin = mkElectron "11.5.0" {
    x86_64-linux = "613ef8ac00c5abda425dfa48778a68f58a2e9c7c1f82539bb1a41afabbd6193f";
    x86_64-darwin = "32937dca29fc397f0b15dbab720ed3edb88eee24f00f911984b307bf12dc8fd5";
    i686-linux = "cd154c56d02d7b1f16e2bcd5650bddf0de9141fdbb8248adc64f6d607e5fb725";
    armv7l-linux = "3f5a41037aaad658051d8bc8b04e8dece72b729dd1a1ed8311b365daa8deea76";
    aarch64-linux = "f698a7743962f553fe36673f1c85bccbd918efba8f6dca3a3df39d41c8e2de3e";
    aarch64-darwin = "749fb6bd676e174de66845b8ac959985f30a773dcb2c05553890bd99b94c9d60";
    headers = "1zkdgpjrh1dc9j8qyrrrh49v24960yhvwi2c530qbpf2azgqj71b";
  };

  electron_12-bin = mkElectron "12.2.3" {
    armv7l-linux = "4de83c34987ac7b3b2d0c8c84f27f9a34d9ea2764ae1e54fb609a95064e7e71a";
    aarch64-linux = "d29d234c09ba810d89ed1fba9e405b6975916ea208d001348379f89b50d1835c";
    x86_64-linux = "deae6d0941762147716b8298476080d961df2a32d0f6f57b244cbe3a2553cd24";
    i686-linux = "11b4f159cd3b89d916cc05b5231c2cde53f0c6fb5be8e881824fde00daa5e8c2";
    x86_64-darwin = "5af34f1198ce9fd17e9fa581f57a8ad2c9333187fb617fe943f30b8cde9e6231";
    aarch64-darwin = "0db2c021a047a4cd5b28eea16490e16bc82592e3f8a4b96fbdc72a292ce13f50";
    headers = "1idam1xirxqxqg4g7n33kdx2skk0r351m00g59a8yx9z82g06ah9";
  };

  electron_13-bin = mkElectron "13.6.9" {
    armv7l-linux = "e70cf80ac17850f3291c19a89235c59a7a6e0c791e7965805872ce584479c419";
    aarch64-linux = "cb570f77e46403a75b99740c41b297154f057dc3b9aa75fd235dccc5619972cf";
    x86_64-linux = "5e29701394041ba2acd8a9bb042d77967c399b8fe007d7ffbd1d3e6bfdb9eb8a";
    i686-linux = "7c31b60ee0e1d9966b8cf977528ace91e10ce25bb289a46eabbcf6087bee50e6";
    x86_64-darwin = "3393f0e87f30be325b76fb2275fe2d5614d995457de77fe00fa6eef2d60f331e";
    aarch64-darwin = "8471777eafc6fb641148a9c6acff2ea41c02a989d4d0a3a460322672d85169df";
    headers = "0vvizddmhprprbdf6bklasz6amwc254bpc9j0zlx23d1pgyxpnhc";
  };

  electron_14-bin = mkElectron "14.2.9" {
    armv7l-linux = "02ae6cd9ec9c2dcb2f550923576a0c851fff3e796a5048dd3806947c541fd564";
    aarch64-linux = "631ba0f716d0272931418de42468114360bd21ec72875605fc32d67620743d2c";
    x86_64-linux = "0a62a41e8ac4592aba347c82f9c40f3fb4c84c7d00b6bb9501d02375cd49cb7d";
    i686-linux = "55e395a209d4a90e2dcd20a78af4724355feaba86411a39e66b977ed39de4d05";
    x86_64-darwin = "1df5b4c4414ade75c6cbfe13d3024702b8ae7c77f3f07b8955b2459fde6a5842";
    aarch64-darwin = "17089e54830976c4216d26e7e2e15ad2224e3b288d94973fed7e67e9b1c213b3";
    headers = "181b2agnf4b5s81p2rdnd6wkw9c2ri4cv1x0wwf7rj60axvzvydm";
  };

<<<<<<< HEAD
  electron_15-bin = mkElectron "15.5.7" {
    armv7l-linux = "58efcdbdd4fc88b4f9d051a0af25a9d38709d870694c9447358fcbddd2c6cdf4";
    aarch64-linux = "994becc7d1b6ded8131cb15d2c80cd0ff443e40784adc25e55acae0c61e06697";
    x86_64-linux = "ecafc973ba31248defad83d5f618b13278a271f5ba8f220509ec21153f5939b0";
    i686-linux = "841f3ba960272692123134bd203b1de657aff0694fa85b2ccc59daffcebc0eb3";
    x86_64-darwin = "c71390382371715bed1e667e2cc2525dd10784519edc4351fe2db82b5ba4f217";
    aarch64-darwin = "55c476877d5d7040a114cc5821f7dced4d65c6110bb205b02c472420b4f4a1d9";
    headers = "00ic356iss1pshb7r06xriqkh9zn75nd1i6cgxcm6al43bxn6vq1";
  };

  electron_16-bin = mkElectron "16.2.8" {
    armv7l-linux = "93ba85035ab57537c3388c7b22a7ba66f9c49368aa8fea9816000c3f0f72e513";
    aarch64-linux = "29024df822cca9a2bbb2b71d82f2ddf5af5cada80c0bd38e8ede420700297c6a";
    x86_64-linux = "68dd612c503a82f9c0ad147e5f1d94213685bfc8fba6c4346fb542ec6fcd14e7";
    i686-linux = "f00ac4d64bb0c4f6c4c6b317a2a7e5731eb6150f2768ccca2526b41cce612df6";
    x86_64-darwin = "d40b00dbf2ef0e42f70b5269255101d3978e709dc3f0b6dbe0c7725fc828b3e1";
    aarch64-darwin = "8b68d24e4902c42b934d1b4de2c0e675039d4289a2e9a4caccc6ad13c3faa5ef";
    headers = "0b09whq5m7qbwy09ni29c23yip3k40sm88sa7ya5i1ysvp5p1v3c";
  };

  electron_17-bin = mkElectron "17.4.11" {
    armv7l-linux = "2f148ad481fe0e06dade070caecf23b7e1564b1b27d775c9350c7a5245998af2";
    aarch64-linux = "53618dc3fc6c04a4b4a44261987969850ad6ae56c8a5dbf21167cf0db7fc99bf";
    x86_64-linux = "c40cc41da8f7958b4edbef953e9b0b4e830689467d1f1993c4d298677e6d0047";
    i686-linux = "9654be64612f157a89928166f220792b5ab76240081a40594d01f763902d1007";
    x86_64-darwin = "abd190e66826500fd5082f083d2795aca08503eff4b38cacf43d575933c99b85";
    aarch64-darwin = "3fa2de3e6f67cc23051c23151c6aaac4d00c7595dda2adca4199242f44ab66bd";
    headers = "1k4aay9p65vi2gkdwk2f9r3lvxn20wkf0krr5arivg1kpi03bzf6";
  };

  electron_18-bin = mkElectron "18.3.15" {
    armv7l-linux = "2cc18781bdc5069878e544603fd66bccb9e8bf098f0250637cb5643cdc23d8bb";
    aarch64-linux = "8fc93d852acc6722d6c4f62a74bc62d56abacb27c2b4ab644415b73e45c2e6b5";
    x86_64-linux = "482101648dbf22e0e2c6be16cf36a9abf57028024abee56e23c143207d6ecdec";
    i686-linux = "1a417ec687b6591800b7123fe60207984fb686156ca3b90dfd56e4ad0c1da4aa";
    x86_64-darwin = "12927ceba4a56abaa96b28eb028f7e92e3b557c45c8b4e03a2178e7494d67ad5";
    aarch64-darwin = "e588cbef49094a7a9d6f104f35a92a74a800a7bdadc52862d243c5e8524ed01b";
    headers = "1rxslb022i45jd84fl311w5v0ski391s3i43kl75zyk4kha7japs";
  };

  electron_19-bin = mkElectron "19.1.9" {
    armv7l-linux = "90b4afbf03dde52953ada2d7082fed9a8954e7547d1d93c6286ba04f9ef68987";
    aarch64-linux = "473e07a6db8a92d4627ef1012dda590c5a04fb3d9804cc5237b033fdb6f52211";
    x86_64-linux = "fd320675f1647e03d96764a906c51c567bf0bcbe0301550e4559d66dd76796df";
    x86_64-darwin = "891545c70cbaed8c09b80c43587d5b517a592a2476de978ac1c6dd96cab8868f";
    aarch64-darwin = "3d38b7f867e32d71bb75e8ba5616835cc5cfac130a70313f5de252040636bc1d";
    headers = "06x325qksh9p4r8q9y3sqwhnk6vmvnjr1qb3f656a646vhjhp4bb";
  };

  electron_20-bin = mkElectron "20.3.12" {
    armv7l-linux = "3319634fe22a8938e5bbabd5b7158ac5691df359aec5f6959bf0ad9fcc0d2af0";
    aarch64-linux = "fb25d52f9416bb626fc9e2b02f06d032653cfa1d96918dd13643bbd3ffcb4529";
    x86_64-linux = "3d21d14e528980327a328f6bab3195ed7bfa1cab97ab7d3dbb023e657f663244";
    x86_64-darwin = "e6c8126a9e40c9b348ab4950b53472de13b66add5ba07ea0f3278ad202b35879";
    aarch64-darwin = "e94465a1e233df6b1bebd565fdc5bb5cc180e87dd7945933ee0f9355bcdbdded";
    headers = "0268rcqvwzjhxz32kd7djfw9dda93cm8xvzqyik0065hwgxwhcn1";
  };

  electron_21-bin = mkElectron "21.4.4" {
    armv7l-linux = "220d9a4fe374f01dd99fe0db5670698d2b1a5c371aaa7fe04385efefb0bbacbe";
    aarch64-linux = "b9214c775f4a767d534890d37de4625ace178b7b38ac0c0d56d87ac8e32bb7e5";
    x86_64-linux = "9a61c8f0ad986dfc3b45d52814ff60fc1190f47a337156ecddee1d8ec34dc086";
    x86_64-darwin = "78ad44ffac3bd2cae4fd4fea14d8ebf9087700b5074eacdb1764527c9d9baa1b";
    aarch64-darwin = "08a362473cdd3db2e8ce21e100680b90968150741809740db75cde4d4dd2af90";
    headers = "03mb1v5xzn2lp317r0mik9dx2nnxc7m26imygk13dgmafydd6aah";
  };

  electron_22-bin = mkElectron "22.3.22" {
    armv7l-linux = "763af3af1bd80be535c49e22e8f2a1a7f6377e6c6e3e4f754ccf351e971b775f";
    aarch64-linux = "8ab1f1cf0008e7624ed38837b611187642e711a8975dd4fa89aaf44f7d6f85f4";
    x86_64-linux = "782008ad1633637991230ded3bd897b7b664a9b63977e65c7b00c69edf5510b0";
    x86_64-darwin = "e0bdff8d045e9bc1e972a82aecd7bc60c8b79e9f75a4752a706b8c6b3753143f";
    aarch64-darwin = "f27834bf1b83f3ffce018fcb232b8593082100d35d27dbdfd55c5ebe4c0ec81b";
    headers = "0r7vyvnbarvm718r9s2r8wspqrl86dbmav4r3f2jialkacrk36vq";
  };

  electron_23-bin = mkElectron "23.3.13" {
    armv7l-linux = "b88424ef80d59ebafe1ded3a48d2f92160921e5973eaad64775173825212a8a9";
    aarch64-linux = "d353329f796798404a09a1f7271a6d824ced5dbe015e5c1d8e809aaa701a3907";
    x86_64-linux = "2f9ab1c3bbacaa74b64f4f6ad92423302cc6b69a135ff1438a84233611e2f440";
    x86_64-darwin = "ee6ccd4ce6c2c7bf3a0fd90b2b6347970df1663d8e48eabfc12136f9d8e2c479";
    aarch64-darwin = "d1091c1444b9dadc39b505808d241269cd988532e7576f506acbf6d9d4e2aa80";
    headers = "04k25z0d6xs2ar5mbbnr0phcs97kvxg28df3njhaniws6wf6qcmg";
  };

  electron_24-bin = mkElectron "24.8.1" {
    armv7l-linux = "ea4881fc28c05d0023607a785baf1fc1d04d3f7721f4828dec3165a667c98dfd";
    aarch64-linux = "0da70bdc89ea7fefa1d22a06444281463a9b93aa930a3785082c8d112f65b699";
    x86_64-linux = "2405d30b841cf5130c00820467565763c7d4b4af6deb61882316a65dae191f66";
    x86_64-darwin = "41e4eb5e4fa921bda8c4138c5d5f614d01c6a7e50977cce151a24b7c26bd6f97";
    aarch64-darwin = "12f461f6bcfee2f07c5063ae9c2da6f364bb5e7f0c1773ac224483824eb5f19f";
    headers = "1n7i77rrwa94gzk31gn6rsalzbjwyaycv5j8a9qxf3xsizr59nz5";
  };

  electron_25-bin = mkElectron "25.7.0" {
    armv7l-linux = "832a68cddb20eb847aca982b89f89e145f50dd483c71c8a705bbb9248fb7c665";
    aarch64-linux = "19e1e2c7ea1ab024f069e3dad6a26605e14b2c605e134484196343118fccf925";
    x86_64-linux = "002641e8103b77060e23b9c77c51ffb942372d01306210cdc3d32fc6ae5d112b";
    x86_64-darwin = "dea726ae9adc1c36206ce8d20ce32f630bcd684b869e0cb302f97c8bd26616d6";
    aarch64-darwin = "76a415165d212a345a5689de83078adc715fc10562bfaa35d7323094780ba683";
    headers = "1v7ap1v520hhghw358k41aahpnaif54qbg6a9dwgmg1di0qwn735";
  };

  electron_26-bin = mkElectron "26.2.1" {
    armv7l-linux = "27469331e1b19f732f67e4b3ae01bba527b2744e31efec1ef76748c45fe7f262";
    aarch64-linux = "fe634b9095120d5b5d2c389ca016c378d1c3ba4f49b33912f9a6d8eb46f76163";
    x86_64-linux = "be4ca43f4dbc82cacb4c48a04f3c4589fd560a80a77dbb9bdf6c81721c0064df";
    x86_64-darwin = "007413187793c94cd248f52d3e00e2d95ed73b7a3b2c5a618f22eba7af94cd1a";
    aarch64-darwin = "4e095994525a0e97e897aad9c1940c8160ce2c9aaf7b6792f31720abc3e04ee6";
    headers = "02z604nzcm8iw29s5lsgjlzwn666h3ikxpdfjg2h0mffm82d0wfk";
=======
  electron_15-bin = mkElectron "15.5.2" {
    armv7l-linux = "da434095fd7cc17d85ebca5eab3510ec7ff73ace4edc933fe2f27a716ca711c0";
    aarch64-linux = "bcec3f962c7acefc8690680a19df9d83721db7e5db55c7b7a8946365139457a6";
    x86_64-linux = "a4a95888c313dbe279f5f9d9dfd99f56a2a1b6b905fb6cba3b284322fe19a530";
    i686-linux = "0fd1dd9027bfdbc573fd39e163b6b3f8c07e8ac1586a554e65e7324e7fa7ea35";
    x86_64-darwin = "688cc1d501d32afa5efe1883be42446b61f404d4a5e84bd9815254b5437c869b";
    aarch64-darwin = "b43237d7612ada2f2dccaf6e13fa70ba938dc48f1e2f895558949dd372171db7";
    headers = "0jbxazkjkm8g8b8d0ini2l4q9z7885mz5vyj74lf85lqdfqzgzc0";
  };

  electron_16-bin = mkElectron "16.2.3" {
    armv7l-linux = "9b442b17349dcec08e6efadecf9d338a7f4b2955635fed2a78374af850ceee5d";
    aarch64-linux = "eec581d162b494a7bcba4b0221f3beac9f359b48fb8612c83ce6ad7ac63094cd";
    x86_64-linux = "2c032baff08b40f106dfcd86e7b63c6275f13e64d26b8c301af704563edf8600";
    i686-linux = "227e9f5670a2d92a814eeda41c7ef4efd8fc6150bee659e0f322a8d2481ecdec";
    x86_64-darwin = "3a51ad480d4085a822b0526018805e64fe82f93b954abe500eaebb3c81c80d45";
    aarch64-darwin = "38c736c336abf8747040f22542d6a0bd785b5a10f6ba01d71335cc5f77a3d0b5";
    headers = "1a9kb89iigwmahjwq14i74rr6gj21gmpc106pg0il73c50khaxpz";
  };

  electron_17-bin = mkElectron "17.4.1" {
    armv7l-linux = "d1329468cb21039fb5b503fc813381f9be4d43422383b44f859b450be0e4200c";
    aarch64-linux = "70d29bca5f884753341a11b0445ccf159c0f43dfae16eb60c53946582c3128b0";
    x86_64-linux = "f9437a86947c418d92eabea14b268dcc4a5dde74cc6927530c1e9195e4aeddf8";
    i686-linux = "436f44d778acc41a4a07cc4ee23ab861e2c4d72e4b1335e3c4ccfd4855deb594";
    x86_64-darwin = "0357bcf841bc246d01df8b838fa5de9856bd48f4fa6b2b4f3053ba3db492e54b";
    aarch64-darwin = "827f6ecb7bc4d4ed88eb22e1b02615465ad13ace918d294c873a67a34c207dcf";
    headers = "064qnwv6gqn502r1cv7vi6ahvgyxcqq7mv0rmk2bxfpkr5x6hgmh";
  };

  electron_18-bin = mkElectron "18.1.0" {
    armv7l-linux = "c2296f3f68938aab4cef07b747d2dd28973625b6717163b9c51fbcf1509fd8ff";
    aarch64-linux = "13bd4998d0d86ccf4cb87d11f9581d5a6063b4585fc4828e130054527dfb9179";
    x86_64-linux = "7f95069d58e6843e6ae2b8f02619d4dcef7db4c35bd6e90b903268d83b939fba";
    i686-linux = "e952d06b3828695636de522e3af8140543ecbe02d7351dd002b0ffb9e2a09705";
    x86_64-darwin = "24dd64a66b820c9553c5e5570907da6c98e808d33fac98072b9c2a8f1659cb14";
    aarch64-darwin = "97adf13306c9b3b304d3e9ddf68f5f7fb9b79c9a1342114e3671182f3cc9e808";
    headers = "0gl30q2igr9c8sjlhyj5w57dm5navpkas5hnz9yl7sasbx66v10v";
  };

  electron_19-bin = mkElectron "19.0.7" {
    armv7l-linux = "d6a6d2d7c0d658695783137d032a50f20843cdfe6582ef985451d741eef4dd32";
    aarch64-linux = "58685d21bb92c2667d20063ab12aabc2e5c2518f3eda84e98a0fa2306456ce57";
    x86_64-linux = "a4c20a068c54c238ae8c440ab8f46d39eda4168d6aa8cffcaae406800b539983";
    x86_64-darwin = "2709dd94e22ecfc8e7de0c7a7009160ed79e95ba91618c7307e24c26a33e978b";
    aarch64-darwin = "f9042bce83fe8446e22f6885285dd5fc2dca048d0b89cbf7f326a46102ffc440";
    headers = "09dbx4qh0rgp5mdm6srz6fgx12zq6b9jqq1k6l3gzyvwigi3wny1";
  };

  electron_20-bin = mkElectron "20.3.11" {
    armv7l-linux = "709b9eb958e9488f6375811041179556b9cd0b8fc1eab6b899ef4a89423f98b2";
    aarch64-linux = "0f488ac9eeda2baa4c4e571fd75ac8e055dac9dcdf83051164232b1005a29224";
    x86_64-linux = "7899bf391ae35e10d78a5da622e506dd4ae859cd8c18953cd2dc54f1a5e5225e";
    x86_64-darwin = "751204887aa553c2a7811d3cb04d71e85359ccce2cf21d38e43eda24575ef4db";
    aarch64-darwin = "8ea1a446b41413b97d83d2955a4800c5f7c9061662f78c3e8d96827741f8e211";
    headers = "06s4z2hs9sbri4jsjrgybq0sn7rrx7zf3iwfg8da1wb6ahwqcd7w";
  };

  electron_21-bin = mkElectron "21.4.0" {
    armv7l-linux = "20ed4fab8b2046e10c999592ea06cd6ef13bc5826bcd7e8874c6e5e3b3cdb5b7";
    aarch64-linux = "5841060f67c23371f2739e043b51f56d04125fe781cc50e298590247477eacf2";
    x86_64-linux = "1c0da48b2b9d1fb320577429298397d67d94fbf5864d6a4f3c6eeadee3114f2e";
    x86_64-darwin = "3eea42022d21b6bb0416da8da787740b908febd2552e74cbac63bf403df0745a";
    aarch64-darwin = "aee691fd7da0343e09c4574d09e0d9962d2d1071f845ae57acf1fd9c76adbd3c";
    headers = "0zvwd3gz5y3yq5jgkswnarv75j05lfaz58w37fidq5aib1hi50hn";
  };

  electron_22-bin = mkElectron "22.3.8" {
    armv7l-linux = "6488e32debf6e4a2027897b7748e2fdb6e27d1d05475e7aacd30e798e92af996";
    aarch64-linux = "ab93be098c74edcc6f66ed461cbe6eb5f8185245edb611252ebb91a07e04ebe4";
    x86_64-linux = "40a2394417c976dbe055fe96875f482bb73731991f547a977d049dba6a067c0e";
    x86_64-darwin = "47cf839bbb59fc9d4abfff9bdfe3ec8ada88c0cfafe451227034e20592565344";
    aarch64-darwin = "6dcc9ae7928f6fa01bc17377bd78ddef4fe5beb9a69ee293a8df60b2cc058a00";
    headers = "1g4d81iwbkhw3b75q4fh1qajxfwwryqfbiqhviz1yqcw01cbah4f";
  };

  electron_23-bin = mkElectron "23.3.1" {
    armv7l-linux = "0a0b4baf598fac6eed150436cccc754277c6c5765dcf06d33bf1457eb570e260";
    aarch64-linux = "6aae5e986fd578d7ba8a6bf0f4631f314d48bac58f66f493e79f35ab9af911c1";
    x86_64-linux = "084e16b84df37e31761cbf7f76effdd673d923c17115608b95a7b0cfc84caa46";
    x86_64-darwin = "811309609df9dcd6e727fac6694b56847a1401d76eee94c26f12343e11a81beb";
    aarch64-darwin = "2c092341413725c7609f6a891e6552dd094807fbce1a6f272be85723041e3b6f";
    headers = "0as0wri865kj9m44qka8by8nw3c4g1hgyc8ar5m18r8kr0x28z00";
  };

  electron_24-bin = mkElectron "24.2.0" {
    armv7l-linux = "c611ec6a6620a199a0656656c191384f498cff7e7831c45e449728379de4ba23";
    aarch64-linux = "e81baa9f45dcf36f10960e823143bd30633ff679b4253a266896028c3b438959";
    x86_64-linux = "8d7780dd2afcfe5e94a2cf574f4fa10a2a2c691227771fca49051c524ac67513";
    x86_64-darwin = "23f77fbde72cad8315e7d370d929cdceb5408f5533494241fc5dd503d8ad0cdc";
    aarch64-darwin = "529d0745e99278c66f631c81edbef22a5ad8871332366002edd371b409850b24";
    headers = "1ydj6fddrn8h6igzim637di39i4vx7fajc9n98nhlzvpmc43rgbs";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
