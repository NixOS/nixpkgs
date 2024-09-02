# Generated using:  ./generate-sdk-packages.sh macos 11.0.1

{ applePackage', callPackage }:

{
Csu = applePackage' "Csu" "88" "macos-11.0.1" "1lzp9x8iv60c2h12q2s89nf49b5hvpqq4a9li44zr2fxszn8lqxh" {};
ICU = callPackage ./ICU/package.nix { };
PowerManagement = applePackage' "PowerManagement" "1132.50.3" "macos-11.0.1" "1sb2nz92vdf6v3h17ry0vgw0z9zsva82lhdrhsf3k60jhfw1fi2v" {};
adv_cmds = applePackage' "adv_cmds" "176" "macos-11.0.1" "0sskwl3jc7llbrlyd1i7qlb03yhm1xkbxd1k9xhh7f9wqhlzq31j" {};
basic_cmds = applePackage' "basic_cmds" "55" "macos-11.0.1" "1913pzk376zfap2fwmrb233rkn4h4l2c65nd7s8ixvrz1r7cz0q5" {};
bootstrap_cmds = callPackage ./bootstrap_cmds/package.nix { };
copyfile = applePackage' "copyfile" "173.40.2" "macos-11.0.1" "1j20909inn2iw8n51b8vk551wznfi3bhfziy8nbv08qj5lk50m04" {};
diskdev_cmds = applePackage' "diskdev_cmds" "667.40.1" "macos-11.0.1" "0wr60vyvgkbc4wyldnsqas0xss2k1fgmbdk3vnhj6v6jqa98l1ny" {};
file_cmds = applePackage' "file_cmds" "321.40.3" "macos-11.0.1" "0p077lnbcy8266m03a0fssj4214bjxh88y3qkspnzcvi0g84k43q" {};
libresolv = applePackage' "libresolv" "68" "macos-11.0.1" "045ahh8nvaam9whryc2f5g5xagwp7d187r80kcff82snp5p66aq1" {};
libutil = applePackage' "libutil" "58.40.2" "macos-11.0.1" "11s0vizk7bg0k0yjx21j8vaji4j4vk57131qbp07i9lpksb3bcy4" {};
network_cmds = applePackage' "network_cmds" "606.40.2" "macos-11.0.1" "1jsy13nraarafq6wmgh3wyir8wrwfra148xsjns7cw7q5xn40a1w" {};
removefile = applePackage' "removefile" "49.40.3" "macos-11.0.1" "0870ihxpmvj8ggaycwlismbgbw9768lz7w6mc9vxf8l6nlc43z4f" {};
shell_cmds = applePackage' "shell_cmds" "216.40.4" "macos-11.0.1" "0wbysc9lwf1xgl686r3yn95rndcmqlp17zc1ig9gsl5fxyy5bghh" {};
text_cmds = applePackage' "text_cmds" "106" "macos-11.0.1" "17fn35m6i866zjrf8da6cq6crydp6vp4zq0aaab243rv1fx303yy" {};
top = applePackage' "top" "129" "macos-11.0.1" "0d9pqmv3mwkfcv7c05hfvnvnn4rbsl92plr5hsazp854pshzqw2k" {};
}
