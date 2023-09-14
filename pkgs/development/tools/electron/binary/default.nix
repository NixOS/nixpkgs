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

  electron-bin = electron_26-bin;

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

  electron_22-bin = mkElectron "22.3.24" {
    armv7l-linux = "bf986ec2e04c1f81a753dc17d71d231e16e0903d9114b1a73b1df0f18281d549";
    aarch64-linux = "055776ed281fa2db76a9e663677155b9631e4c6ac57c1e86938c789913c72fe7";
    x86_64-linux = "0c48912ff2bcbfe7e7c80eae76b82e2ba1e03cc872c0c6817faa560155447edd";
    x86_64-darwin = "a2adc99b44fbded082cbb5f1c49eceaf0c6f678c5ba951332b2c902b4fa7f63e";
    aarch64-darwin = "2ac36fdd664cb53c6cbc8ac67ac66e95e6418db4009636fbb865df97b711c818";
    headers = "1817viv29v1lgph9rcknm6rz64x6w2l8p0ng681644cv4m5gjsq1";
  };

  electron_23-bin = mkElectron "23.3.13" {
    armv7l-linux = "b88424ef80d59ebafe1ded3a48d2f92160921e5973eaad64775173825212a8a9";
    aarch64-linux = "d353329f796798404a09a1f7271a6d824ced5dbe015e5c1d8e809aaa701a3907";
    x86_64-linux = "2f9ab1c3bbacaa74b64f4f6ad92423302cc6b69a135ff1438a84233611e2f440";
    x86_64-darwin = "ee6ccd4ce6c2c7bf3a0fd90b2b6347970df1663d8e48eabfc12136f9d8e2c479";
    aarch64-darwin = "d1091c1444b9dadc39b505808d241269cd988532e7576f506acbf6d9d4e2aa80";
    headers = "04k25z0d6xs2ar5mbbnr0phcs97kvxg28df3njhaniws6wf6qcmg";
  };

  electron_24-bin = mkElectron "24.8.3" {
    armv7l-linux = "93dc26ce72b2b4cafaf1c09091c23c764294a95da040b515963c5a269fc4112a";
    aarch64-linux = "6684c37e427335818db146bb7b9c860be72ea582064fad349a54c62042676439";
    x86_64-linux = "fcc2754fecdc6ffb814938ae7c806c8ab7d68c748d5906ae3e4b0f3d90eda2e1";
    x86_64-darwin = "73f1913a9594057a47d473ff697c36ebb3d7d2fa012a24d301624af15fe9f251";
    aarch64-darwin = "1b276595078b2733c33570a0d27309117711d176629580c09bd31e5e3edb21f2";
    headers = "1rd0nww6gxvdzw6ja17gv5kd0wszjs9bcfspkp0iamsp5d9ixjf8";
  };

  electron_25-bin = mkElectron "25.8.1" {
    armv7l-linux = "dd3390de2426a1cea9d3176e404b8fb250844a9b0e48cf01822fa66f3c3c4a48";
    aarch64-linux = "931208419f859f528e19805ae14b5b075213bc40dd20da9e03d8b71d849c147d";
    x86_64-linux = "de556aef0a80a8fe7b2b39d74ab0bdecc65d72bba3b7349460d18ef2a22fa323";
    x86_64-darwin = "fe61a3221d4c5dc9415dc2cce81010db61bb4a5ab5021d1023f48786dbaf0b28";
    aarch64-darwin = "985f4beee009ef6dbe7af75009a1b281aff591b989ee544bd4d2c814f9c4428d";
    headers = "1kkkxida3cbril65lmm0lkps787mhrrylzvp0j35rc1ip32b7sda";
  };

  electron_26-bin = mkElectron "26.2.1" {
    armv7l-linux = "27469331e1b19f732f67e4b3ae01bba527b2744e31efec1ef76748c45fe7f262";
    aarch64-linux = "fe634b9095120d5b5d2c389ca016c378d1c3ba4f49b33912f9a6d8eb46f76163";
    x86_64-linux = "be4ca43f4dbc82cacb4c48a04f3c4589fd560a80a77dbb9bdf6c81721c0064df";
    x86_64-darwin = "007413187793c94cd248f52d3e00e2d95ed73b7a3b2c5a618f22eba7af94cd1a";
    aarch64-darwin = "4e095994525a0e97e897aad9c1940c8160ce2c9aaf7b6792f31720abc3e04ee6";
    headers = "02z604nzcm8iw29s5lsgjlzwn666h3ikxpdfjg2h0mffm82d0wfk";
  };
}
